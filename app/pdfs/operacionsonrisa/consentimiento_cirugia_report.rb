# encoding: utf-8
require "prawn/measurement_extensions"

class ConsentimientoCirugiaReport < Prawn::Document
  def initialize(paciente)
    super(:page_size => "A4", :bottom_margin => 50)
    font_size 9
    @color_texto = '3E4D4A'
    header
    body(paciente)
  end

  def header

    stroke_horizontal_rule
    bounding_box([0,cursor], :width => self.bounds.right) do

      pad(20){
        text "CONSENTIMIENTO INFORMADO PARA LA CIRUGÍA DEL LABIO FISURADO Y DEL PALADAR HENDIDO", size: 12, style: :bold, :align => :center
        text "CLINICA MULTIDISCIPLINARIA DE LABIO Y PALADAR HENDIDO", size: 12, style: :bold, :align => :center
        # time = Time.now.strftime("%d/%m/%Y")
        # text "Fecha: #{time}", :align => :center
      }
    end
    stroke_horizontal_rule
  end

  def body(paciente)
    move_down 6.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "Para satisfacción de los DERECHOS DEL PACIENTE, como instrumento favorecedor del correcto uso de los Procedimientos Diagnósticos y Terapéuticos.",size: 12,:align => :justify
    end
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "DESCRIPCIÓN DEL PROCEDIMIENTO",size: 12,:align => :justify,style: :bold
    end
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "Las fisuras del labio y del paladar son las malformaciones congénitas faciales mayores más frecuentes, y son debidas a alteraciones en el desarrollo del labio y paladar durante el embarazo.",size: 12,:align => :justify
    end
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "El grado de malformación es variable, pudiendo afectar al labio y/o paladar en diferentes grados. La fisura labio-palatina conlleva alteraciones funcionales y estéticas, con alteraciones de la pronunciación de las palabras y al deglutir, malformación labial, nasal, del paladar, de la musculatura de la faringe y de la posición de los dientes, así como posibles alteraciones en la salida de los dientes temporales y de los definitivos, así como del crecimiento de los huesos de la cara. El tratamiento de este tipo de malformaciones supone generalmente varias intervenciones quirúrgicas, así como el trabajo coordinado con Odontólogos, Fonoaudiólogos, Otorrinolaringólogos, Psicólogos, y Nutricionistas.",size: 12,:align => :justify
    end
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "Dichas intervenciones quirúrgicas buscarán el cierre de las zonas fisuradas y la reposición anatómica más correcta posible, pudiendo para ello precisar la utilización de injertos óseos y/o de cartílago, así como transposición de tejidos locales o a distancia. En la mayoría de los casos el acto operatorio precisa anestesia general, con los riesgos inherentes a la misma.",size: 12,:align => :justify
    end
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "Entiendo que estos procedimientos intentan corregir las lesiones producidas por la malformación congénita y que mi aspecto exterior difícilmente será perfecto, y que pueden producirse secuelas derivadas de la malformación y/o de la intervención quirúrgica recibida, pudiendo necesitarse más tarde otros tratamientos.",size: 12,:align => :justify
    end
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "RIESGOS DEL PROCEDIMIENTO",size: 12,:align => :justify,style: :bold
    end
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "Las complicaciones estadísticamente más frecuentes de los tratamientos del labio y paladar fisurados son varias, y dependerán de la gravedad de la malformación, pudiendo incluir los siguientes que se citan en forma ilustrativa y no de forma taxativa:",size: 12,:align => :justify
    end
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "• Hematomas y edemas tras la cirugía.",size: 12,:align => :justify
      text "• Cicatrices antiestéticas.",size: 12,:align => :justify
      text "• Malformación nasal.",size: 12,:align => :justify
      text "• Pérdidas de piezas dentarias.",size: 12,:align => :justify
      text "• Pérdida de hueso y de segmentos labiales.",size: 12,:align => :justify
      text "• Comunicación entre la boca y la nariz.",size: 12,:align => :justify
      text "• Apertura de puntos de sutura.",size: 12,:align => :justify
      text "• Dificultad respiratoria.",size: 12,:align => :justify
      text "• Infecciones de la herida y pérdida de material del injerto óseo.",size: 12,:align => :justify
      text "• Deformidad en silbido del labio superior.",size: 12,:align => :justify
      text "• Disminución o pérdida temporal o permanente de la sensibilidad de la cara.",size: 12,:align => :justify
      text "• Mala posición de los segmentos óseos maxilares.",size: 12,:align => :justify
    end
    move_down 6.mm
    footer
    start_new_page
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "RIESGOS ESPECIFICOS EN MI CASO Y OTRAS COMPLICACIONES DE MÍNIMA RELEVANCIA ESTADÍSTICA:",size: 12,:align => :justify
    end
    move_down 6.mm
    stroke_horizontal_rule
    move_down 6.mm
    stroke_horizontal_rule
    move_down 6.mm
    stroke_horizontal_rule
    move_down 6.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "El/la Médico me ha explicado de forma satisfactoria qué es, cómo se realiza y para qué sirve este procedimiento/intervención/exploración.",size: 12,:align => :justify
    end
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "Me ha explicado también en forma detallada los cuidados postoperatorios que deberé guardar y cumplir después de la cirugía a fin de que la misma evolucione de la mejor manera minimizando las posibilidades de complicaciones.",size: 12,:align => :justify
    end
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "Me comprometo a cumplir dichas indicaciones y a acudir a los controles establecidos todas las veces que sea necesario.",size: 12,:align => :justify
    end
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "También me ha explicado los riesgos existentes, las posibles molestias o complicaciones, que éste es el procedimiento más adecuado para mi situación clínica actual, y las consecuencias previsibles de su no realización.",size: 12,:align => :justify
    end
    move_down 3.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "He comprendido perfectamente todo lo anterior, he podido aclarar las dudas planteadas, y DOY MI CONSENTIMIENTO para que me realicen dicho procedimiento/intervención/exploración, pudiendo retirar este consentimiento cuando lo desee.",size: 12,:align => :justify
    end

    move_down 10.mm
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

    move_down 10.mm
    bounding_box([0,cursor], :width => self.bounds.right) do
      text "Asunción, #{Time.now.strftime("%d")} de #{obtenerMes(Time.now.strftime("%m"))} de #{Time.now.strftime("%Y")}",size: 12,:align => :right
    end
    move_down 90.mm
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

  def obtenerMes(mes)
    meses = ['enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre']
    return meses[Integer(mes)-1]
  end



  end
end
