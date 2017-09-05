require "prawn/measurement_extensions"

class RevocacionCirugiaReport < Prawn::Document
  def initialize(paciente,colaborador)
    super(:page_size => "A4", :bottom_margin => 50)
    font_size 9
    @color_texto = '3E4D4A'
    header
    body(paciente,colaborador)
  end

  def header

    stroke_horizontal_rule
    bounding_box([0,cursor], :width => self.bounds.right) do

      pad(20){
        text "REVOCACION DEL CONSENTIMIENTO", size: 12, style: :bold, :align => :left
        # time = Time.now.strftime("%d/%m/%Y")
        # text "Fecha: #{time}", :align => :center
      }
    end
    stroke_horizontal_rule
  end

  def body(paciente,colaborador)
    move_down 6.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "En pleno uso de mis facultades, he decidido libremente no realizar el procedimiento arriba descrito. He sido informado de las consecuencias de la suspensión de éste, pese a lo cual, quiero revocar el consentimiento previamente otorgado. Para que así conste, firmo el presente documento.",size: 12,:align => :justify
    end
    move_down 6.mm

    if(paciente.persona.razon_social)
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "#{paciente.persona.razon_social}",size: 12,:align => :justify
      end
    end
    stroke_horizontal_rule
    move_down 2.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "PACIENTE  / TUTOR LEGAL O FAMILIAR (aclarar grado de parentesco)",size: 12,:align => :justify
    end
    move_down 4.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      if(paciente.persona.ci_ruc)
      text "C I. Nº: #{paciente.persona.ci_ruc}",size: 12,:align => :justify
      else
        text "C I. Nº____________________",size: 12,:align => :justify
      end
    end
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "SI UD. RECONOCE HABER RECIBIDO UNA INFORMACIÓN ADECUADA Y ACEPTA QUE SE LE PRACTIQUE EL PROCEDIMIENTO DESCRITO, PERO REHÚSA FIRMAR ESTE CONSENTIMIENTO, O QUIERE HACER ALGUNA INDICACIÓN CONCRETA, INDIQUE POR FAVOR LOS MOTIVOS DE ESTA DECISIÓN ",size: 12,:align => :justify
    end
    move_down 6.mm
    stroke_horizontal_rule
    move_down 6.mm
    stroke_horizontal_rule
    move_down 6.mm
    stroke_horizontal_rule
    move_down 6.mm


    if(paciente.persona.razon_social)
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "#{paciente.persona.razon_social}",size: 12,:align => :justify
      end
    end
    stroke_horizontal_rule
    move_down 2.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "PACIENTE  / TUTOR LEGAL O FAMILIAR (aclarar grado de parentesco)",size: 12,:align => :justify
    end
    move_down 4.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      if(paciente.persona.ci_ruc)
      text "C I. Nº: #{paciente.persona.ci_ruc}",size: 12,:align => :justify
      else
        text "C I. Nº____________________",size: 12,:align => :justify
      end
    end
    move_down 8.mm
    if(colaborador.tipo_colaborador.nombre.eql? "Doctor" and colaborador.persona.razon_social)
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "#{colaborador.persona.razon_social}",size: 12,:align => :justify
      end
    end
    stroke_horizontal_rule
    move_down 2.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "Nombre y firma del Médico Responsable",size: 12,:align => :justify
    end
    move_down 4.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      if(colaborador.tipo_colaborador.nombre.eql? "Doctor" and colaborador.persona.ci_ruc)
      text "C I. Nº: #{paciente.persona.ci_ruc}",size: 12,:align => :justify
      else
        text "C I. Nº____________________",size: 12,:align => :justify
      end
    end
    move_down 6.mm

    bounding_box([0,cursor], :width => self.bounds.right) do
      text "Asunción, #{Time.now.strftime("%d")} de #{obtenerMes(Time.now.strftime("%m"))} de #{Time.now.strftime("%Y")}",size: 12,:align => :right
    end
    move_down 6.mm

    bounding_box([0,cursor], :width => self.bounds.right) do
      text "La información contenida en este documento es confidencial y el mismo será incorporado a la Ficha Médica del paciente y no podrá ser cedido a terceros, salvo en los casos  previstos por la Ley. ",size: 12,:align => :justify
    end
    move_down 50.mm
    footer

  end

  def footer
    stroke_horizontal_rule
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "Delfín Chamorro esq. Nicasio Villalba, Fernando de la Mora – Paraguay ",size: 12,:align => :center
      text "Tel: +595 21 67 00 14 ∙  Cel: (0972) 456 000",size: 12,:align => :center
      text "www.operacionsonrisa.org.py",size: 12,:align => :center
    end
  end

  def obtenerMes(mes)
    meses = ['enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre']
    return meses[Integer(mes)-1]
  end


end
