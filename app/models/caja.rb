# encoding: utf-8
class Caja < ActiveRecord::Base
  belongs_to :sucursal
  belongs_to :moneda
  belongs_to :usuario
  validates :codigo, presence: true
  validate :descripcion, allow_blank: true

  attr_accessor :limite_alivio
  attr_accessor :necesita_alivio

  scope :by_codigo, -> codigo { where("codigo ilike ?", "%#{codigo}%") }
  scope :by_descripcion, -> descripcion { where("descripcion ilike ?", "%#{descripcion}%") }
  scope :sucursal, -> sucursal { where("sucursal_id = ?", "#{sucursal}") }
  scope :by_caja_destino_id, -> caja_destino_id { where("id != ?", "#{caja_destino_id}")}
  scope :by_tipo_caja, -> tipo_caja {where("tipo_caja ilike ?", "%#{tipo_caja}%")}
  scope :by_username, -> username {joins(:usuario).where("usuarios.username ilike ?", "%#{username}%" )}
  scope :by_all_attributes, -> value { 
    where("cajas.codigo ilike ? OR cajas.descripcion ilike ? OR cajas.tipo_caja ilike ?", 
          "%#{value}%", "%#{value}%", "%#{value}%" )
  }
  scope :unpaged, -> { order("descripcion") }
  scope :by_sucursal_name, -> username {joins(:sucursal).where("sucursales.descripcion ilike ?", "%#{username}%" )}
  scope :by_sucursal_id, -> sucursal_id { where("sucursal_id = ? and tipo_caja = 'P'", "#{sucursal_id}")}
  

  def self.by_cajas_permitidas(current_user, current_sucursal)
    if current_user.isAuthorized("FE_new_movimientos_all_cajas")
      return Caja.all
    else
      return Caja.by_username(current_user.username) + Caja.by_sucursal_id(current_sucursal.id)
    end
  end

  def self.by_sucursal(current_sucursal)
    puts "****** >>>>>> ******* >>>>>> CURRENT SUCURSAL: #{current_sucursal.id}"
    cajas = Caja.by_sucursal_id(current_sucursal.id)
    puts "#{cajas.first.id}"
    return cajas
  end

  def self.by_usuario(current_user)
    puts ">>>>>>>>>>>>> BUSCANDO CAJAS PARA EL USUARIO #{current_user.username}"
    return Caja.by_username(current_user.username)
  end
	
	def limiteAlivio(current_sucursal)
		monto_alivio = ParametrosEmpresa.by_empresa(current_sucursal.empresa.id).first.monto_alivio
    if monto_alivio.nil?
      monto_alivio = 0
		end
    self.limite_alivio = monto_alivio
  end
	
	def necesitaAlivio(current_sucursal)
	    limiteAlivio(current_sucursal)
	    self.necesita_alivio = false
		if self.limite_alivio > 0
			self.necesita_alivio = self.saldo > self.limite_alivio
		end
  	end

  def forzar_cierre
    ultima_operacion = Operacion.where("reversado=false").order(created_at: :desc).first
    if !ultima_operacion.nil? and abierta and (ultima_operacion.created_at < DateTime.now.beginning_of_day)
      puts "Abierta #{abierta} - Created at: #{ultima_operacion.created_at} - Now.beginning_of_day #{DateTime.now.beginning_of_day}"
      return true
    end

    return false
  end
	
	def self.verificar_alivio
		aliviar = false
		mensaje = "Advertencia de alivio de cajas!\nLas siguientes cajas necesitan alivio:"
		#puts "Se hara verificacion de alivio de caja"
		empresas = Empresa.by_activo
		empresas.each do |empresa|
			agregado_en_esta_empresa = false
			#puts "Se verificaran las cajas de la empresa: " + empresa.nombre
			#Obtenemos el parametro de la empresa
			monto_alivio = ParametrosEmpresa.by_empresa(empresa.id).first.monto_alivio
			if(monto_alivio == nil)
				puts "La empresa no tiene seteado el parametro monto alivio"
				next
			end
			#puts "El monto alivio de la empresa es: " + monto_alivio.to_s
			#Obtenemos todas las sucursales de la empresa
			sucursales = Sucursal.by_empresa(empresa.id)
			sucursales.each do |sucursal|
				agregado_en_esta_sucursal = false
				#Por cada sucursal, iteramos sobre sus cajas
				sucursal.cajas.each do |caja|
					if caja.tipo_caja != "U"
						next
					end
					if caja.saldo > monto_alivio
						#puts "La caja " + caja.descripcion + " necesita alivio"
						if !agregado_en_esta_empresa
							mensaje +=  "\nEmpresa: " + empresa.nombre + ", monto de alivio configurado: " + monto_alivio.to_int.to_s
							agregado_en_esta_empresa = true
						end
						if !agregado_en_esta_sucursal
							mensaje += "\n  Sucursal: " + empresa.nombre
							agregado_en_esta_sucursal = true
						end
						mensaje += "\n    * Caja: " + caja.descripcion
						aliviar = true
					end
				end
			end
		end
		if aliviar
			#Obtenemos todos los usuarios con rol de administrador
			mails  = []
			usuarios = Usuario.by_rol("administrador")
			usuarios.each do |usuario| 
				if !usuario.email.nil?
					mails.push usuario.email
				end
			end
			AlivioCajaNotifier.alivio_caja_mail(mails, mensaje)
			#puts mensaje
		end
	end

end
