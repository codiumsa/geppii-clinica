# encoding: utf-8
require "prawn/measurement_extensions"

class RecetaReport < Prawn::Document
  def initialize(consulta)
    # super(:page_size => "A4", :bottom_margin => 50)
    super(:page_size => "A4", :page_layout => :landscape, :bottom_margin => 0, :left_margin =>0)
    font_size 9
    @color_texto = '3E4D4A'
    body(consulta)
  end

  def body(consulta)
    filename = "#{Rails.root}/app/assets/images/logo.jpg"
    image filename, :at => [245.251, cursor],:scale => 0.4
    image filename, :at => [651.196, cursor],:scale => 0.4
    # image dice, :at => [50, 450], :scale => 0.75 
    move_down 15.mm
    altura = cursor
    bounding_box([41.047,altura], :width => 358.851, :height => 350) do
      # stroke_bounds
      text "RP.",size: 14,:align => :left, :style => :bold_italic
      text "",size: 14,:align => :center
      font "Helvetica", :style => :normal
      text "#{consulta.receta}",size: 12,:align => :justify
    end
    move_down 5.mm
    bounding_box([41.047,cursor], :width => 358.851) do
      text "___________________________________",size: 12,:align => :justify
    end
    move_down 3.mm
    if !consulta.colaborador.nil?
      bounding_box([41.047,cursor], :width => 358.851, :height => 370) do
        text "Médico: #{consulta.colaborador.persona.razon_social}",size: 12,:align => :justify
        text "Reg. Prof. Nº: #{consulta.colaborador.licencia}",size: 12,:align => :justify
      end
    else
      bounding_box([41.047,cursor], :width => 358.851, :height => 370) do
        text "Médico: ",size: 12,:align => :justify
        text "Reg. Prof. Nº: ",size: 12,:align => :justify
      end
    end



    bounding_box([441.992,altura], :width => 358.851, :height => 400) do      
      text "Indicaciones",size: 14,:align => :center, :style => :bold_italic
      text "",size: 14,:align => :center
      text "#{consulta.indicaciones}",size: 12,:align => :justify
    end
    move_down 2.mm
    footer
  end

  def footer
    

    bounding_box([41.047,70], :width => 358.851) do
      text "Delfín Chamorro esq. Nicasio Villalba, Fernando de la Mora – Paraguay ",size: 12,:align => :center
      text "Tel: +595 21 67 00 14 ∙  Cel: (0972) 456 000",size: 12,:align => :center
      text "www.operacionsonrisa.org.py",size: 12,:align => :center
    end
    bounding_box([441.992,70], :width => 358.851) do
      text "Delfín Chamorro esq. Nicasio Villalba, Fernando de la Mora – Paraguay ",size: 12,:align => :center
      text "Tel: +595 21 67 00 14 ∙  Cel: (0972) 456 000",size: 12,:align => :center
      text "www.operacionsonrisa.org.py",size: 12,:align => :center
    end

  def obtenerMes(mes)
    meses = ['enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre']
    return meses[Integer(mes)-1]
  end



  end
end
