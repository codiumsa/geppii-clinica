require "prawn/measurement_extensions"

class TratamientosConsultorioReport < Prawn::Document
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
      pad(10){
        text "CONSENTIMIENTO INFORMADO", size: 12, :styles => [:bold, :underline], :align => :center

        # time = Time.now.strftime("%d/%m/%Y")
        # text "Fecha: #{time}", :align => :center
      }
    end
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "DECLARACIÓN DE HABER SIDO INFORMADO Y DE DAR EL CONSENTIMIENTO PARA LA REALIZACIÓN DE TRATAMIENTOS EN LA CLÍNICA  MULTIDISCIPLINARIA DEL LABIO Y PALADAR HENDIDO",size: 12,:align => :center,style: :bold
    end
    move_down 10

    stroke_horizontal_rule
  end

  def body(paciente,colaborador)
      move_down 4.mm
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "Nombre y Apellido del Paciente: #{paciente.persona.razon_social}",size: 12,:align => :justify
        text "Edad: #{age(paciente.persona.fecha_nacimiento.to_datetime)}",size: 12,:align => :justify
        text "C I. Nº: #{paciente.persona.ci_ruc}",size: 12,:align => :justify
      end
      move_down 3.mm
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "Declaro bajo mi responsabilidad",size: 12,:align => :justify,style: :bold
      end
      move_down 3.mm
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "Que el Dr./Lic. #{colaborador.persona.razon_social}, con Registro Profesional No _________________ me ha explicado personalmente el tratamiento que debo seguir en mi caso, que en resumen consiste en ",size: 12,:align => :justify
      end
      move_down 6.mm
      stroke_horizontal_rule
      move_down 6.mm
      stroke_horizontal_rule
      move_down 6.mm
      stroke_horizontal_rule
      move_down 3.mm
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "Que por las explicaciones dadas por el Dr./Lic. #{colaborador.persona.razon_social}, he comprendido las finalidades del tratamiento y se me ha informado de los riesgos que pueden existir en la intervención, tales como:",size: 12,:align => :justify
      end
      move_down 6.mm
      stroke_horizontal_rule
      move_down 6.mm
      stroke_horizontal_rule
      move_down 6.mm
      stroke_horizontal_rule
      move_down 3.mm
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "Que consiento que el citado profesional practique la intervención explicada y consiento igualmente que, si en el curso de ella estima necesario o conveniente llevar a cabo cualquier medida, que también me ha explicado, lo haga sin dilación.",size: 12,:align => :justify
      end
      move_down 6.mm
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "Así mismo, declaro que debo cumplir con las siguientes reglas:",size: 12,:align => :justify
      end
      move_down 3.mm

      bounding_box([10.mm,cursor], :width => self.bounds.right-10.mm) do
        text "1.  Asistir regularmente según indicación, caso contrario, el tratamiento será suspendido.",size: 12,:align => :justify
        text "2.	Cuidar la higiene del paciente y aparatos brindados para asegurar el éxito del tratamiento. ",size: 12,:align => :justify
        text "3.	Cumplir las reglas de uso de los aparatos brindados, reconociendo que la falta de uso puede dejar sin efecto el mismo, debiendo correr el paciente con los gastos de reposición.",size: 12,:align => :justify
        text "4.	Por rotura o pérdida, gastos de reposición a cargo del paciente.",size: 12,:align => :justify
      end
      move_down 3.mm
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "Y para que así conste, lo firmo y dejo impresa mi huella digital.",size: 12,:align => :justify
      end
      move_down 3.mm
      time = Time.now.strftime("%d/%m/%Y")
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "Fecha: #{time}",size: 12,:align => :left
      end
      move_down 3.mm
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "Firma del Paciente/Representante Legal:_______________________",size: 12,:align => :left
      end
      move_down 3.mm
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "C.I.N°:_______________________",size: 12,:align => :left
      end
      move_down 3.mm
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "Aclaración del Paciente/Representante Legal:_______________________ ",size: 12,:align => :left
      end
      move_down 3.mm
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "C.I.N°:_______________________",size: 12,:align => :left
      end
      move_down 6.mm
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "Firma del Profesional:_______________________   C.I.N°:_______________________",size: 12,:align => :left
      end
      move_down 3.mm
      bounding_box([0,cursor], :width => self.bounds.right) do
        text "Aclaración del Profesional:_______________________   C.I.N°:_______________________",size: 12,:align => :left
      end
      move_down 3.mm
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

  def age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def obtenerMes(mes)
    meses = ['enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre']
    return meses[Integer(mes)-1]
  end
end
