class ContactoSponsorsMailer < ActionMailer::Base
  default from: "no-reply@codium.com.py"

  def contacto_sponsors
    @contactos = ContactoDetalle.where(fecha_siguiente: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).order("fecha_siguiente ASC")
    if @contactos.length > 0
      get_mails.each do |mail|
        mail( 
          :to => mail,
          :subject => "Patrocinadores a contactar esta semana - #{Date.today.strftime("%d/%m/%Y")}]"
        ).deliver!
      end
    end
  end


  private
  def get_mails
    mails  = []
    administradores = Usuario.by_rol("administrador")
    asistentes = Usuario.by_rol("asistente_administrativa")
    coordinadores = Usuario.by_rol("coordinador_campanhas")
    administradores.each do |u| 
      if !u.email.nil?
        mails.push u.email
      end
    end
    asistentes.each do |u| 
      if !u.email.nil?
        mails.push u.email
      end
    end
    coordinadores.each do |u| 
      if !u.email.nil?
        mails.push u.email
      end
    end
    return mails.uniq
  end
  
end
