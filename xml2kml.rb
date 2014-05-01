require "nokogiri"
require "ruby_kml"

#Opening XML file and parse it with Nokogiri
f = File.open("traces.xml")
doc = Nokogiri::XML(f)
f.close

#Creating the list of coordinates for KML path
path = ""
doc.xpath("//Point").each do |p|
  path=path+p.attr('lon')+","+p.attr('lat')+",0 "
end

#Creation of the KML file with only one path
kml = KMLFile.new
kml.objects << KML::Document.new(
      :name => 'Paths',
      :description => 'Path for EPL',
      :styles => [
        KML::Style.new(
          :id => 'yellowLineGreenPoly',
          :line_style => KML::LineStyle.new(:color => '7f00ffff', :width => 4),
          :poly_style => KML::PolyStyle.new(:color => '7f00ff00')
        )
      ],
      :features => [
        KML::Placemark.new(
          :name => 'Path for EPL',
          :description => 'Path for EPL',
          :style_url => '#yellowLineGreenPoly',
          :geometry => KML::LineString.new(
            :extrude => true,
            :tessellate => true,
            :altitude_mode => 'absolute',
            :coordinates => path
          )
        )
      ]
    )
#Saving the KML file
File.open("output.kml", 'w') { |file| file.write(kml.render) } 
