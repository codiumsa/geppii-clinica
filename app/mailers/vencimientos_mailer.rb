class VencimientosMailer < ActionMailer::Base
  default from: "no-reply@codium.com.py"

  def vencimiento_semanal
    @lote = Lote.where(fecha_vencimiento: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).order("fecha_vencimiento ASC")
    get_mails.each do |mail|
      mail( 
        :to => mail,
        :subject => "Productos que vencen esta semana - #{Date.today.strftime("%d/%m/%Y")}]"
      ).deliver!
    end
  end

  def vencimiento_mensual
    @lote = Lote.where(fecha_vencimiento: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month).order("fecha_vencimiento ASC")
    get_mails.each do |mail|
      mail( 
          :to => mail,
          :subject => "Productos que vencen este mes - #{Date.today.strftime("%d/%m/%Y")}]"
        ).deliver!
    end
  end


  private
  def get_mails
    mails  = []
    administradores = Usuario.by_rol("administrador")
    asistentes = Usuario.by_rol("asistente_administrativa")
    depositeros = Usuario.by_rol("depositero")
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
    depositeros.each do |u| 
      if !u.email.nil?
        mails.push u.email
      end
    end
    return mails.uniq
  end

end
