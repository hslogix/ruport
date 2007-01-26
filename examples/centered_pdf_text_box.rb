require "ruport"                             

class Document < Ruport::Renderer
  
  include Ruport::Renderer::Helpers
  
  required_option :text
  required_option :author
  option :heading

  stage :document_body
  finalize :document                            
end


class CenteredPDFTextBox < Ruport::Format::PDF

  Document.add_format self, :pdf

  def build_document_body

    add_text "-- " << options.author << " --",
             :justification => :center, :font_size => 20 
    
    
    c = pdf_writer.absolute_x_middle - 239/2
    
    #img,x,y,width,height
    center_image_in_box("RWEmerson.jpg",c,325,239,359)
 
    rounded_text_box(options.text) do |o|
       o.radius = 5
       o.width     = layout.width  || 400
       o.height    = layout.height || 130
       o.font_size = layout.font_size || 12
       o.heading   = options.heading
       
       o.x = pdf_writer.absolute_x_middle - o.width/2
       o.y = 300
    end         

  end
  
  def finalize_document
    output << pdf_writer.render
  end
end

a = Document.render_pdf { |r|
  r.heading = "a good quote"
  r.author  = "Ralph Waldo Emerson"
  r.text = <<EOS
A foolish consistency is the hobgoblin of little minds, adored by little
statesmen and philosophers and divines. With consistency a great soul has simply
nothing to do. He may as well concern himself with his shadow on the wall. Speak
what you think now in hard words and to-morrow speak what to-morrow thinks in
hard words again, though it contradict every thing you said to-day.--"Ah, so you
shall be sure to be misunderstood."--Is it so bad then to be misunderstood?
Pythagoras was misunderstood, and Socrates, and Jesus, and Luther, and
Copernicus, and Galileo, and Newton, and every pure and wise spirit that ever
took flesh. To be great is to be misunderstood. . . .
EOS

}

puts a