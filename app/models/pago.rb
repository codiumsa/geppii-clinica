class Pago < ActiveRecord::Base
  belongs_to :venta
  belongs_to :compra
  belongs_to :moneda
	belongs_to :usuario_solicitud_descuento, class_name: 'Usuario'
  belongs_to :usuario_aprobacion_descuento, class_name: 'Usuario'
	has_many :pago_detalles, :dependent => :destroy
	
	
	scope :by_venta, -> venta_id { where("venta_id = ?", "#{venta_id}").order(:created_at) }
	scope :by_compra, -> compra_id { where("compra_id = ?", "#{compra_id}").order(:created_at) }
  scope :by_activo, -> { where("borrado = false") }

  scope :by_not_pendiente, -> { where("estado <> 'Pendiente'").order(:prestamo_id).order(:fecha_pago) }
  scope :by_not_pendiente_with_descuento, -> { where("estado <> 'Pendiente' and usuario_aprobacion_descuento_id is not null").order(:prestamo_id).order(:fecha_pago) }
  scope :by_estado_pago, -> estado { where("estado = ?", "#{estado}").order(:prestamo_id).order(:fecha_pago) }

  scope :by_usuario_aprobador_descuento_id, -> usuario_id { where("usuario_aprobacion_descuento_id = ?", "#{usuario_id}") }
  scope :by_username_aprobador_descuento, -> username { joins(:usuario_aprobacion_descuento).where("usuarios.username ilike ?", "%#{username}%") }
  scope :by_nombre_aprobador_descuento, -> value { joins(:usuario_aprobacion_descuento).where("usuarios.nombre ilike ?", "%#{value}%") }
  scope :by_apellido_aprobador_descuento, -> value { joins(:usuario_aprobacion_descuento).where("usuarios.apellido ilike ?", "%#{value}%") }

  scope :by_fecha_creacion_before, -> before{ where("fecha_pago::date < ?", Date.parse(before)) }
  scope :by_fecha_creacion_on, -> on { where("fecha_pago::date = ?", Date.parse(on)) }
  scope :by_fecha_creacion_after, -> after { where("fecha_pago::date > ? ", Date.parse(after)) }

  scope :by_fecha_aprobacion_before, -> before{ where("fecha_aprobacion_descuento::date < ?", Date.parse(before)) }
  scope :by_fecha_aprobacion_on, -> on { where("fecha_aprobacion_descuento::date = ?", Date.parse(on)) }
  scope :by_fecha_aprobacion_after, -> after { where("fecha_aprobacion_descuento::date > ?", Date.parse(after)) }

  #scope :by_numero_cliente, ->value{ joins(:prestamo => :cliente).where("clientes.numero_cliente = ?", "#{value}") }
  #scope :by_numero_prestamo, ->value{ joins(:prestamo).where("prestamos.numero = ?", "#{value}") }
  
  #scope :by_multa_eq, ->value{ where("multa = ?", "#{value}") }
  #scope :by_multa_gt, ->value{ where("multa > ?", "#{value}") }
  #scope :by_multa_lt, ->value{ where("multa < ?", "#{value}") }

  scope :by_descuento_eq, ->value{ where("descuento = ?", "#{value}") }
  scope :by_descuento_gt, ->value{ where("descuento > ?", "#{value}") }
  scope :by_descuento_lt, ->value{ where("descuento < ?", "#{value}") }

  #scope :by_descuento_interes_punitorio_eq, ->value{ where("descuento_interes_punitorio = ?", "#{value}") }
  #scope :by_descuento_interes_punitorio_gt, ->value{ where("descuento_interes_punitorio > ?", "#{value}") }
  #scope :by_descuento_interes_punitorio_lt, ->value{ where("descuento_interes_punitorio < ?", "#{value}") }

  #scope :by_descuento_interes_moratorio_eq, ->value{ where("descuento_interes_moratorio = ?", "#{value}") }
  #scope :by_descuento_interes_moratorio_gt, ->value{ where("descuento_interes_moratorio > ?", "#{value}") }
  #scope :by_descuento_interes_moratorio_lt, ->value{ where("descuento_interes_moratorio < ?", "#{value}") }

  #scope :by_descuento_gastos_administrativos_eq, ->value{ where("descuento_gastos_administrativos = ?", "#{value}") }
  #scope :by_descuento_gastos_administrativos_gt, ->value{ where("descuento_gastos_administrativos > ?", "#{value}") }
  #scope :by_descuento_gastos_administrativos_lt, ->value{ where("descuento_gastos_administrativos < ?", "#{value}") }

  scope :by_total_eq, ->value{ where("total = ?", "#{value}") }
  scope :by_total_gt, ->value{ where("total > ?", "#{value}") }
  scope :by_total_lt, ->value{ where("total < ?", "#{value}") }

  
  default_scope order(created_at: :desc)
	
	def guardar(usuario_logueado)
		transaction do
      #Si no hay descuento
			if self.descuento == 0
        self.estado = Settings.estados_pagos.pendiente
      else
        self.estado = Settings.estados_pagos.descuento_solicitado
      end


      #Si se solicito descuento, guardar el usuario solicitante
			if(self.estado == Settings.estados_pagos.descuento_solicitado)
				self.usuario_solicitud_descuento = usuario_logueado
			end

      self.fecha_actualizacion_interes = Date.today
			self.borrado = false

      if self.venta_id
        venta = Venta.find(self.venta_id)
      end
      if venta
        sucursal = Sucursal.find(venta.sucursal_id)
        parametro = ParametrosEmpresa.by_empresa(sucursal.empresa_id).first
        if parametro.sequences_por_empresa
          empresa = Empresa.find(sucursal.empresa_id)
          if venta.uso_interno
            self.nro_recibo = empresa.get_next_nro_recibo_interno
          else
            self.nro_recibo = empresa.get_next_nro_recibo
          end
        else
          if venta.uso_interno
            #self.nro_recibo = empresa.get_next_nro_recibo_interno
          else
            #self.nro_recibo = empresa.get_next_nro_recibo
          end
        end
      end
     
			save!
      #if self.descuento == 0
				#puts 'Hay que concretar!'
				#self.concretar
			#end

		end
	end
	
	def concretar
		
		transaction do
			
			#Se pone el estado a concretado
			self.estado = Settings.estados_pagos.concretado
			
			#Se deben procesar los detalles, ya que fueron almacenados con solamente 
			#la cuota relacionada seteada
			detalles_ordenados = []
			if( not self.compra.nil?)
				self.pago_detalles.sort! { |a,b| a.compra_cuota.nro_cuota <=> b.compra_cuota.nro_cuota }
				detalles_ordenados = self.pago_detalles
			end
			if( not self.venta.nil?)
				self.pago_detalles.sort! { |a,b| a.venta_cuota.nro_cuota <=> b.venta_cuota.nro_cuota }
				detalles_ordenados = self.pago_detalles
			end
			
			total_pagado = self.total
			detalles_ordenados.each do |detalle|
				desde_compra = false
				desde_venta = false
				
				#Esto sirve para determinar la cuota, si es de compra o de venta
				if(not detalle.compra_cuota_id.nil?)
					desde_compra = true
					cuota = detalle.compra_cuota
				end
				if(not detalle.venta_cuota_id.nil?)
					desde_venta = true
					cuota = detalle.venta_cuota
				end
				
				#inicialmente, intentara descontar el monto de la cuota
				descontar = cuota.pendiente				
				
				
				
				#Si lo que queda del total pagado es mayor o igual a lo que se debe descontar,
				#la cuota debe quedar como pagada
				if total_pagado >= descontar
					cuota.estado = Settings.estadosCuotas.pagada
          cuota.cancelado = true
					detalle.monto_cuota = descontar
					total_pagado = total_pagado - descontar
					
				#Si no, entonces se pagara parcialmente la cuota actual	
				else
					cuota.estado = Settings.estadosCuotas.parcialmente_pagada
					detalle.monto_cuota = total_pagado
					total_pagado = 0
				end
				
				detalle.save!
				cuota.save!
			end	
				#Se verifica si es necesario marcar como pagada la compra o venta
				if(not self.venta_id.nil?)
					marcar_pagado = true
					self.venta.venta_cuotas.each do |cuota|
						if cuota.estado != Settings.estadosCuotas.pagada
							marcar_pagado = false
						end
					end
					
					if marcar_pagado
						self.venta.pagado = true
						self.venta.save!
					end
				end
				
				if(not self.compra_id.nil?)
					marcar_pagado = true
					self.compra.compra_cuotas.each do |cuota|
						if cuota.estado != Settings.estadosCuotas.pagada
							marcar_pagado = false
						end
					end
					
					if marcar_pagado
						self.compra.pagado = true
						self.compra.save!
					end
				end
				
				
			end
		#end
		
		self.save!
		
	end
	
	
  

  #Guarda un pago, generando (o actualizando) sus detalles
  def guardarPrestamo(usuario_logueado)
    transaction do
      self.anticipo = false
      #Si no hay descuento
      #if self.descuento_gastos_cobranza == 0 and self.descuento_interes_compensatorio == 0 and self.descuento_interes_moratorio == 0 and self.descuento_interes_punitorio == 0
			if self.descuento == 0
        self.estado = Settings.estados_pagos.pendiente
      else
        self.estado = Settings.estados_pagos.descuento_solicitado
      end

      #if self.impugnado and (self.estado != Settings.estados_pagos.concretado and self.estado != Settings.estados_pagos.descuento_solicitado)
       # self.estado = Settings.estados_pagos.congelado
      #end

      #Si se solicito descuento, guardar el usuario solicitante
			if(self.estado == Settings.estados_pagos.descuento_solicitado)
				self.usuario_solicitud_descuento = usuario_logueado
			end

      self.fecha_actualizacion_interes = Date.today
      save!

      saldo = self.total - self.descuento_total

      saldo_descuento_gastos_cobranza = self.descuento_gastos_cobranza
      saldo_descuento_interes_compensatorio = self.descuento_interes_compensatorio
      saldo_descuento_interes_punitorio = self.descuento_interes_punitorio
      saldo_descuento_interes_moratorio = self.descuento_interes_moratorio

      cuotas_pagadas = 0
      #Esto parece muy complicado, pero potencialmente permite guardar que parte de cada concepto se cubrio con plata
      #y que parte con descuento
      pago_detalles.sort! { |a,b| a.cuota.numero_cuota <=> b.cuota.numero_cuota }.each do |detalle|
        if not fecha_pago.nil?
          #Se actualizan los intereses moratorios y punitorios a la fecha_pago, sin persistir a la BD
          #Esto, porque el pago puede crearse por adelantado
          detalle.cuota.actualizar_interes_moratorio_punitorio(fecha_pago, false)
        end
        #Si alcanza el saldo, pagar los gastos de cobranza - el descuento asociado
        #Se espera que para cada cuota asociada a este pago, puedan pagarse como minimo los gastos de cobranza
        if saldo > 0 or saldo_descuento_gastos_cobranza > 0
          #Se calcula el monto a pagar como gastos de cobranza
          gastos_cobranza = GastoCobranza.getGastoCobranza(detalle.cuota, self.fecha_pago - detalle.cuota.fecha_vencimiento)
          #Se calcula el monto cubierto por el descuento
          parte_descuento_gastos_cobranza = (gastos_cobranza > saldo_descuento_gastos_cobranza) ? saldo_descuento_gastos_cobranza : gastos_cobranza
          #Lo que queda por pagar una vez aplicado el descuento
          saldo_gastos_cobranza = gastos_cobranza - parte_descuento_gastos_cobranza
          #Se calcula el monto de gastos_cobranza del detalle = (parte saldo + parte descuento)
          pago_gastos_cobranza = saldo > saldo_gastos_cobranza ? gastos_cobranza : saldo + parte_descuento_gastos_cobranza
          detalle.gastos_cobranza = pago_gastos_cobranza
          #Disminuye el descuento disponible para este concepto
          saldo_descuento_gastos_cobranza -= parte_descuento_gastos_cobranza
          #Disminuye el saldo disponible
          saldo -= (detalle.gastos_cobranza - parte_descuento_gastos_cobranza)
        end

        #Si queda saldo o descuento, pagar los intereses punitorios
        if saldo > 0 or saldo_descuento_interes_punitorio > 0
          #Se calcula el monto cubierto por el descuento          
          parte_descuento_interes_punitorio = (detalle.cuota.monto_interes_punitorio > saldo_descuento_interes_punitorio) ? saldo_descuento_interes_punitorio : detalle.cuota.monto_interes_punitorio
          #Lo que queda por pagar una vez aplicado el descuento          
          saldo_interes_punitorio = detalle.cuota.monto_interes_punitorio - parte_descuento_interes_punitorio
          #Se calcula el monto de intereses punitorios del detalle = (parte saldo + parte descuento)          
          pago_interes_punitorio = saldo > saldo_interes_punitorio ? detalle.cuota.monto_interes_punitorio : saldo + parte_descuento_interes_punitorio        
          detalle.monto_interes_punitorio = pago_interes_punitorio
          #Disminuye el descuento disponible para este concepto          
          saldo_descuento_interes_punitorio -= parte_descuento_interes_punitorio
          #Disminuye el saldo disponible
          saldo -= (pago_interes_punitorio - parte_descuento_interes_punitorio)
        end

        if saldo > 0 or saldo_descuento_interes_moratorio > 0
          #Se calcula el monto cubierto por el descuento          
          parte_descuento_interes_moratorio = (detalle.cuota.monto_interes_moratorio > saldo_descuento_interes_moratorio) ? saldo_descuento_interes_moratorio : detalle.cuota.monto_interes_moratorio
          #Lo que queda por pagar una vez aplicado el descuento                    
          saldo_interes_moratorio = detalle.cuota.monto_interes_moratorio - parte_descuento_interes_moratorio
          #Se calcula el monto de intereses moratorios del detalle = (parte saldo + parte descuento)                    
          pago_interes_moratorio = saldo > saldo_interes_moratorio ? detalle.cuota.monto_interes_moratorio : saldo + parte_descuento_interes_moratorio
          detalle.monto_interes_moratorio = pago_interes_moratorio
          #Disminuye el descuento disponible para este concepto          
          saldo_descuento_interes_moratorio -= parte_descuento_interes_moratorio
          #Disminuye el saldo disponible
          saldo -= (pago_interes_moratorio - parte_descuento_interes_moratorio)
        end

        if saldo > 0 or saldo_descuento_interes_compensatorio > 0
          #Se calcula el monto cubierto por el descuento          
          parte_descuento_interes_compensatorio = (detalle.cuota.monto_interes_pendiente > saldo_descuento_interes_compensatorio) ? saldo_descuento_interes_compensatorio : detalle.cuota.monto_interes_pendiente
          #Lo que queda por pagar una vez aplicado el descuento                    
          saldo_interes_compensatorio = detalle.cuota.monto_interes_pendiente - parte_descuento_interes_compensatorio
          #Se calcula el monto de intereses compensatorios del detalle = (parte saldo + parte descuento)                    
          pago_interes_compensatorio = saldo > saldo_interes_compensatorio ? detalle.cuota.monto_interes_pendiente : saldo + parte_descuento_interes_compensatorio
          detalle.monto_interes = pago_interes_compensatorio
          #Disminuye el descuento disponible para este concepto          
          saldo_descuento_interes_compensatorio -= parte_descuento_interes_compensatorio
          #Disminuye el saldo disponible
          saldo -= (pago_interes_compensatorio -  parte_descuento_interes_compensatorio)
        end

        if saldo > 0
          pago_capital = saldo > detalle.cuota.monto_capital_pendiente ? detalle.cuota.monto_capital_pendiente : saldo
          detalle.monto_capital = pago_capital
          saldo -= pago_capital
        end

        detalle.save!
      end

      #Se vuelven a setear y persistir los intereses compensatorios y punitorios al dia de hoy
      if not fecha_pago.nil?
        self.prestamo.cuotas.each { |cuota| cuota.actualizar_interes_moratorio_punitorio(Date.today, true) }
        #Caso migracion: si se recalculan los intereses al concretar (caso normal) o bien la fecha de pago es mayor o igual a hoy.
        #Si no se recalculan los intereses al concretar y la fecha de pago es menor a hoy, se esta concretando un pago
        #correspondiente a un dia anterior, por lo cual no se deben actualizar los intereses
        if not (fecha_pago >= Date.today or Settings.recalcular_intereses_al_concretar)
          self.pago_detalles { |detalle| detalle.cuota.actualizar_interes_moratorio_punitorio(fecha_pago, true) }
        end
      end
    end
  end


  def borrar
    transaction do
      #Solo se puede borrar el pago mas reciente, si exiten otros pagos mas recientes, abortar la operacion
			if(not self.venta_id.nil?)
      	ultimo_pago = venta.pagos.select { |pago| pago.borrado == false and pago.estado != Settings.estados_pagos.descuento_rechazado } \
        .sort! { |a,b| a.created_at <=> b.created_at }.last
			end
			if(not self.compra_id.nil?)
				ultimo_pago = compra.pagos.select { |pago| pago.borrado == false and pago.estado != Settings.estados_pagos.descuento_rechazado } \
        .sort! { |a,b| a.created_at <=> b.created_at }.last
			end
      if ultimo_pago.id != self.id
        self.errors[:base] << "Existe un pago posterior. Imposible borrar este pago."
        raise ActiveRecord::Rollback
      end

      self.borrado = true
      save!

      #Si el pago era concretado
      if self.estado == Settings.estados_pagos.concretado
				self.estado = Settings.estados_pagos.parcialmente_pagada
				self.save!
				#Se pasa la compra o la venta como no pagada
        if(not self.venta_id.nil?)
					if self.venta.pagado == true
						self.venta.pagado = false
						self.venta.save!
					end
				end
				if(not self.compra_id.nil?)
					if self.compra.pagado == true
						self.compra.pagado = false
						self.compra.save!
					end
				end
				self.pago_detalles.each do |detalle|
					if (not detalle.compra_cuota_id.nil?)
						cuota = detalle.compra_cuota
					end
					if (not detalle.venta_cuota_id.nil?)
						cuota = detalle.venta_cuota
					end
					#Si el monto del detalle de pago es igual al monto de la cuota, entonces e pasa a pendiente
					if cuota.monto == detalle.monto_cuota
						cuota.estado = Settings.estadosCuotas.pendiente
					#Si no era igual, entonces es una cuota que se encontraba como parcialmente pagada
					else
						cuota.estado = Settings.estadosCuotas.parcialmente_pagada
					end
					
					cuota.save!
				end
			end
    end
   
  end

  def concretarPrestamo
    transaction do
      #El pago no se puede concretar antes de fecha_pago
      if not self.fecha_pago.nil? and self.fecha_pago > Date.today
        self.errors[:base] << "No se puede concretar el pago antes de #{self.fecha_pago}."
        raise ActiveRecord::Rollback
      end

      #Antes de concretar, actualizamos los intereses al dia de hoy
      #Se comenta para no actualizar los intereses
      self.guardar self.usuario_solicitud_descuento

      #Se paga alguna cuota con mora?
      pago_con_mora = !self.pago_detalles.select { |detalle| detalle.monto_interes_moratorio > 0 }.empty?

      #Se actualiza y el estado y la fecha_pago
      fecha_registro = fecha_pago
      self.update_attribute(:estado, Settings.estados_pagos.concretado)

      #La fecha de pago es la fecha en la cual se concreta (recibe el dinero) del pago en cuestion
      #EXCEPTO si se esta concretando un pago de un dia anterior (que ya se cobro)
      #y el sistema no actualiza los intereses moratorio y punitorio (configuracion)
      if not (fecha_pago < Date.today and not Settings.recalcular_intereses_al_concretar)
        self.update_attribute(:fecha_pago, Date.today)
      end

      cantidad_cuotas = self.prestamo.cuotas.length
      ultima_cuota_pagada = -1
      offset_vencimiento = 0

      self.pago_detalles.sort! { |a,b| a.cuota.numero_cuota <=> b.cuota.numero_cuota }.each do |detalle|
        #Si ya se pago todo la cuota, cambiar el estado
        if(detalle.cuota.monto_capital_pendiente == 0)
          detalle.cuota.estado = Settings.estadosCuotas.pagada
          #Si se pago la ultima cuota, actualizar el prestamo
          if(detalle.cuota.numero_cuota == cantidad_cuotas)
            #Si se pago por adelantado alguna cuota, es una cancelacion
            if self.is_adelanto
              self.prestamo.estado = Settings.estados_prestamos.cancelado
            else
              self.prestamo.estado = Settings.estados_prestamos.pagado
            end
            if self.refinanciamiento
              if pago_con_mora
                self.prestamo.estado = Settings.estados_prestamos.refinanciado
              else
                self.prestamo.estado = Settings.estados_prestamos.reestructurado
              end
            end
            self.prestamo.save!
          end
          #Si se pago antes del devengamiento de intereses, es un anticipo, se correran las fechas de vencimiento
          if Date.today < (detalle.cuota.fecha_vencimiento - 1.month)
            self.anticipo = true
            offset_vencimiento += 1
          end
          #Al salir del loop esta variable contendra el mayor numero_cuota pagado
          ultima_cuota_pagada = detalle.cuota.numero_cuota
        else
          detalle.cuota.estado = Settings.estadosCuotas.parcialmente_pagada
        end
        #Se actualizan intereses moratorio y punitorio de la cuota, que cambian al concretarse el pago
        fecha_actualizacion = Date.today
        if not (fecha_registro >= Date.today or Settings.recalcular_intereses_al_concretar)
          fecha_actualizacion = fecha_registro
        end
        detalle.cuota.actualizar_interes_moratorio_punitorio(fecha_actualizacion)
      end

      #Corrimiento de fechas de vencimiento
      if self.anticipo and ultima_cuota_pagada > 0
        correr_vencimiento(ultima_cuota_pagada, offset_vencimiento)
      end

      #Si todas las cuotas sin pagar aun no han vencido, actualizar el estado del prestamo
      if self.prestamo.cuotas.select { |cuota| cuota.fecha_vencimiento > Date.today and cuota.estado != Settings.estadosCuotas.pagada}.empty?
        self.prestamo.estado = Settings.estados_prestamos.vigente
        self.prestamo.save!
      end

    end
  end

  #Corre las fechas de vencimiento de las cuotas con numero > a @ultima_cuota_pagada, @offset_vencimiento meses
  def correr_vencimiento(ultima_cuota_pagada, offset_vencimiento)
    self.prestamo.cuotas.select {|cuota| cuota.numero_cuota > ultima_cuota_pagada}. each do |cuota|
      cuota.fecha_vencimiento -= offset_vencimiento.month
      cuota.save!
    end
  end


  def is_adelanto
    #si es que el pago tiene algun detalle asociado a una cuota cuyo interes no fue devengado
    !self.pago_detalles.select {|detalle| self.fecha_pago < (detalle.cuota.fecha_vencimiento - 1.month)}.empty?
  end


  #Procedimiento que se corre en batch para actualizar los valores de intereses moratorio y punitorio de los pagos pendientes
  def self.actualizar_pagos
    transaction do
      Pago.where("estado <> ? and estado <> ? and borrado = false", Settings.estados_pagos.concretado, Settings.estados_pagos.descuento_rechazado).each do |pago|
          if Date.today > self.fecha_pago
            days_to_add = Date.today - pago.fecha_actualizacion_intereses
            interes_prestamo = pago.prestamo.tasa_nominal
            delta = 0
            pago.pago_detalles.each do |detalle|
              delta_interes_moratorio = Cuota.interes_moratorio(detalle.cuota.monto_capital_pendiente, interes_prestamo, days_to_add)
              detalle.monto_interes_moratorio += delta_interes_moratorio

              delta_interes_punitorio = Cuota.interes_punitorio(delta_moratorio, interes_prestamo)
              detalle.monto_interes_moratorio += delta_interes_punitorio

              delta += delta_interes_moratorio + delta_interes_punitorio
              detalle.fecha_actualizacion_intereses = Date.today
              detalle.save!
            end
            pago.total += delta
            pago.save!
          end
        end
      end
  end

  #true si no existe otro pago pendiente, se usa para la creacion. Solo un pago puede crearse a la vez.
  def unico_pendiente
		if (not self.compra.nil?)
			pagos_pendientes = self.compra.pagos.select do |pago|
				pendiente = (pago.estado == Settings.estados_pagos.pendiente or pago.estado == Settings.estados_pagos.descuento_solicitado or pago.estado == Settings.estados_pagos.descuento_aprobado)
				pendiente and not pago.borrado
			end
		end
		
		if (not self.venta.nil?)
			pagos_pendientes = self.venta.pagos.select do |pago|
				pendiente = (pago.estado == Settings.estados_pagos.pendiente or pago.estado == Settings.estados_pagos.descuento_solicitado or pago.estado == Settings.estados_pagos.descuento_aprobado)
				pendiente and not pago.borrado
			end

		end
    #refinanciamientos_pendientes = Solicitud.by_prestamo_padre(self.prestamo.id)
    pagos_pendientes.empty?
  end

  def descuento_total
    self.descuento
  end

end
