require_relative '../pdfs/vencimiento_cuotas_report.rb'
class VencimientoCuotaNotifier < ActionMailer::Base
  default from: "no-reply@codium.com.py"
   
  # envia un correo indicando qué proceso se ejecutó exitosamente.
  def vencimiento_cuota_notifier_mail(lista, tipo)
      if lista.length > 0
      pdf = VencimientoCuotaReportPdf.new(lista,tipo)
      nombre_archivo = "Vencimiento_cuotas_#{tipo}-#{Date.today.strftime("%d-%m-%Y")}"
      attachments["#{nombre_archivo}.pdf"] = {mime_type: 'application/pdf',content: (VencimientoCuotaReportPdf.new(lista,tipo)).render}
      mail( 
        :to => 'ricpar11@gmail.com',
        # :cc => 'vanecanhete@gmail.com, soporte@codium.com.py',
        :subject => "[Vencimiento cuotas de #{tipo} - #{Date.today.strftime("%d/%m/%Y")}]",
        body: ''
      ).deliver!
    end
  end
end