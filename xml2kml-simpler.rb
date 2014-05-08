require "nokogiri"

#Opening XML file and parse it with Nokogiri
f = File.open(ARGV[0])
doc = Nokogiri::XML(f)
f.close

kml_coordinates=""
#Creating the list of coordinates for KML path
      doc.xpath("//FlightRecord").each do |p|
        agl=p.attr('AGL')
        msl=p.attr('MSL')
        date=p.attr('date')
        inner = Nokogiri::XML(p.to_s)
        lat=inner.xpath("//Point").attr('lat')
        lon=inner.xpath("//Point").attr('lon')
        heading=inner.xpath("//Heading").attr('angle')
        speed=inner.xpath("//GroundSpeed").attr('kmPerHour')
        
        kml_coordinates=kml_coordinates+"#{lon},#{lat},#{msl} "
    end

kml_header="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<kml xmlns=\"http://www.opengis.net/kml/2.2\">
<Document>
<name>Paths</name>
<description>Export for EPL</description>
<Style id=\"yellowLineGreenPoly\"><LineStyle><color>7f00ffff</color><width>4</width></LineStyle><PolyStyle><color>7f00ff00</color></PolyStyle></Style>
<Placemark>
<name>Absolute Extruded</name>
<description>Trajectory of flight</description>
<styleUrl>#yellowLineGreenPoly</styleUrl>
<LineString>
<extrude>1</extrude>
<tessellate>1</tessellate>
<altitudeMode>absolute</altitudeMode>
<coordinates>"

kml_footer="</coordinates></LineString></Placemark></Document></kml>"

#Saving the KML file
open("#{ARGV[0]}.kml", 'w') { |f|
  f << kml_header
  f << kml_coordinates
  f << kml_footer
}
