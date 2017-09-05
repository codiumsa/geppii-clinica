class AlivioCajaNotifier < ActionMailer::Base
  default from: "no-reply@codium.com.py"
   
  # envia un correo indicando qué proceso se ejecutó exitosamente.
	def alivio_caja_mail(destinatarios, mensaje)
		destinatarios.each do |destinatario|
			puts "Se enviara mail de advertencia de alivio de caja a: " + destinatario
			if destinatario.nil?
				next
			end
      mail( 
				:to => destinatario,
        # :cc => 'vanecanhete@gmail.com, soporte@codium.com.py',
				:subject => "[Advertencia de alivio de cajas - #{Date.today.strftime("%d/%m/%Y")}]",
				body: mensaje
      ).deliver!
    end
  end
end