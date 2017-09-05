# encoding: utf-8

require 'enumerator'


class Venta < ActiveRecord::Base
  include ActiveModel::Validations
  #para cargar el valor por defeto del nro_factura
  after_create :reload

  belongs_to :usuario
  belongs_to :cliente
  belongs_to :sucursal
  belongs_to :tipo_credito
  belongs_to :vendedor
  belongs_to :moneda
  belongs_to :tipo_salida
  belongs_to :medio_pago
  belongs_to :consultorio
  belongs_to :campanha
  belongs_to :persona
  belongs_to :colaborador
  belongs_to :tarjeta
  belongs_to :garante, class_name: 'Cliente'
  belongs_to :venta, :foreign_key => 'venta_padre_id'

  has_many :venta_detalles, :dependent => :destroy
  has_many :venta_cuotas, :dependent => :destroy
  has_many :venta_medios, :dependent => :destroy
  has_many :pagos, :dependent => :destroy

  #validates :cliente_id, presence: true;
  validates :nro_factura, uniqueness: {message: :nro_factura_taken, scope: :sucursal_id, allow_nil: true }
  validate :validate_venta, :on => :create

  attr_accessor :es_edicion
  attr_accessor :precio_editable
  attr_accessor :nombre_campanha

  scope :existencia_nro_factura, -> nro_factura, sucursal_id { where("nro_factura = ? AND sucursal_id = ?", nro_factura, sucursal_id) }
  scope :by_cliente_id, -> cliente_id { where("cliente_id = ?", "#{cliente_id}") }
  scope :by_cliente_nombre, -> cliente_nombre {joins(:cliente).where("clientes.nombre ilike ?", "%#{cliente_nombre}%" )}
  scope :by_cliente_apellido, -> cliente_apellido {joins(:cliente).where("clientes.apellido ilike ?", "%#{cliente_apellido}%" )}
  scope :by_vendedor_nombre, -> vendedor_nombre {joins(:vendedor).where("vendedores.nombre ilike ?", "%#{vendedor_nombre}%" )}
  scope :by_vendedor_apellido, -> vendedor_apellido {joins(:vendedor).where("vendedores.apellido ilike ?", "%#{vendedor_apellido}%" )}
  scope :by_cliente_ruc, -> cliente_ruc {joins(:cliente).joins(:persona).where("clientes.personas.ci_ruc ilike ?", "%#{cliente_ruc}%" )}
  scope :by_sucursal_id, -> sucursal_id { where("sucursal_id = ?", "#{sucursal_id}") }
  scope :by_campanha_id, -> campanha_id { where("campanha_id = ?", "#{campanha_id}") }
  scope :by_consultorio_id, -> consultorio_id { where("consultorio_id = ?", "#{consultorio_id}") }
  scope :by_empresa_id, -> empresa_id {joins(:sucursal).where("sucursales.empresa_id = ?", "#{empresa_id}" )}
  scope :by_nro_factura, -> nro_factura { where("nro_factura = ?", "#{nro_factura}") }
  scope :by_credito, -> credito { where("credito = ?", "#{credito}") }
  scope :by_tipo_credito_id, -> tipo_credito_id { where("tipo_credito_id = ?", "#{tipo_credito_id}") }
  scope :by_fecha_registro_before, -> before{ where("fecha_registro::date < ?", Date.parse(before)) }
  scope :by_fecha_registro_on, -> on { where("fecha_registro::date = ?", Date.parse(on)) }
  scope :by_fecha_registro_after, -> after { where("fecha_registro::date > ?", Date.parse(after)) }
  scope :by_total_gt, -> gt { where("total > ?", gt) }
  scope :by_total_eq, -> eq { where("total = ?", eq) }
  scope :by_total_lt, -> lt { where("total < ? ", lt) }

  scope :tiene_descuento, -> { where("ventas.descuento > 0 ") }
  scope :tiene_descuento_redondeo, -> { where("ventas.descuento_redondeo > 0 ") }
  scope :tiene_descuento_detalle, -> {joins(:venta_detalles).where("venta_detalles.descuento > 0" )}
  scope :tiene_descuento_detalle_sin_promo, -> {joins(:venta_detalles).where("venta_detalles.descuento > 0 and venta_detalles.promocion_id is null" )}
  scope :tiene_descuento_detalle_con_promo, -> {joins(:venta_detalles).where("venta_detalles.descuento > 0 and venta_detalles.promocion_id is not null" )}

  scope :by_usuario_id, -> usuario_id { where("usuario_id = ?", "#{usuario_id}")}

  scope :by_producto_id, -> producto_id {joins(:venta_detalles).where("venta_detalles.producto_id = ?", "#{producto_id}" )}
  scope :by_promocion_id, -> promocion_id {joins(:venta_detalles).where("venta_detalles.promocion_id = ?", "#{promocion_id}" )}
  scope :sucursal, -> sucursal { where("sucursal_id = ?", "#{sucursal}") }
  scope :by_codigo_barra, -> codigo_barra {
    joins(:venta_detalles => :producto).where("productos.codigo_barra ilike ?", "%#{codigo_barra}%")
  }
  scope :by_imei, -> imei { where("id in (select venta_id from venta_detalles where venta_detalles.imei ilike ?)", "%#{imei}%") }
  scope :by_moneda_id, -> moneda_id { where("ventas.moneda_id = ?", "#{moneda_id}") }
  scope :by_anulados, -> anulado { where("anulado = ?", "#{anulado}") }
  scope :by_tipo_salida, -> codigo { joins(:tipo_salida).where("tipo_salidas.codigo ilike ?","#{codigo}") }
  scope :by_tipos_salida, -> codigos { joins(:tipo_salida).where("tipo_salidas.codigo in (?)",codigos) }
  default_scope order("updated_at DESC")

  def precio_editable
    @precio_editable || false
  end

  def nombre_campanha

    if (!campanha.nil? and !campanha.nombre.nil?)
      return campanha.nombre
    else
      return 'Clínica'
    end
  end

  #default_scope { where(estado_valido: true) }

  scope :by_all_attributes, -> value {
    joins(:cliente).
    where("ventas.deuda = ? OR ventas.descuento = ? OR ventas.total = ? OR ventas.nro_factura ilike ? OR clientes.nombre ilike ? OR clientes.apellido ilike ? OR to_char(ventas.fecha_registro, 'DD/MM/YYYY') ilike ? OR ventas.id in (select venta_id from venta_detalles where venta_detalles.imei ilike ?)",
          number?(value) ? value.to_i : nil,
          number?(value) ? value.to_i : nil,
          number?(value) ? value.to_i : nil,
          "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%")
  }

  def self.number? (string)
    true if Float(string) rescue false
  end

  def getPersona
    if persona.nil?
      if !cliente.nil?
        return cliente.persona
      end
    else
      persona
    end
  end

  def self.generar_facturas(cleanedParams, params, current_user_id, soporta_cajas_impresion,
                            current_caja_impresion, current_caja, current_user, current_sucursal)

    transaction do

      if Settings.autenticacion.logueo_con_sucursal
        #si se usa logueo con sucursal, se usa la sucursal_id donde está logueado
        sucursal_id = current_sucursal.id
      else
        sucursal_id = cleanedParams[:sucursal_id]
      end

      if Settings.venta.nro_factura_autogenerado
        #se genera siempre un número para el número de factura
        cleanedParams.delete(:nro_factura)
      else
        #solo se autogenera si se deja nro_factura vacio
        if !venta_inner_params[:nro_factura] || venta_inner_params[:nro_factura].length == 0
          cleanedParams.delete(:nro_factura)
        end
      end

      #para distribuir entre las ventas generadas
      descuentoRedondeo = cleanedParams[:descuento_redondeo]
      cleanedParams.delete(:descuento_redondeo)

      sucursal = Sucursal.find(sucursal_id)
      parametro = ParametrosEmpresa.by_empresa(sucursal.empresa_id).first

      if (not params[:venta][:venta_detalles].nil?)
        detallesParam = params[:venta][:venta_detalles].each_slice(parametro.max_detalles_ventas).to_a
        #if !parametro.soporta_impresion_factura_venta
        puts 'detallesParam tiene '
        puts detallesParam.length
        puts 'elementos '
        puts detallesParam

        @ventas = []
        for detallesRaw in detallesParam
          @venta = Venta.new(cleanedParams)
          @venta.precio_editable = Usuario.where("id = ? ",current_user).first.isAuthorized("FE_editar_precio_venta")
          puts @venta.precio_editable
          @venta.sucursal_id = sucursal_id

          if not @venta.cliente_id and not @venta.persona_id
            #si no hay cliente seteado, se usa el cliente sin nombre
            @venta.cliente_id = Cliente.find_by_ruc(Settings.valores_por_defecto.cliente.ruc_sin_nombre).id
          end

          detalles = []
          detallesRaw.each do |detalle|
            if(detalle[:lote_id])
              @detalle_venta = VentaDetalle.new(producto_id: detalle[:producto_id],
                                                cantidad: detalle[:cantidad],
                                                caliente: detalle[:caliente],
                                                precio: detalle[:precio],
                                                descuento: detalle[:descuento],
                                                promocion_id: detalle[:promocion_id],
                                                imei: detalle[:imei],
                                                cotizacion_id: detalle[:cotizacion_id],
                                                monto_cotizacion: detalle[:monto_cotizacion],
                                                moneda_id: detalle[:moneda_id],
                                                lote_id: detalle[:lote_id]
                                                )

            else
              @lote = Lote.where("codigo_lote ilike ?", detalle[:codigo_lote]).first
              @detalle_venta = VentaDetalle.new(producto_id: detalle[:producto_id],
                                                cantidad: detalle[:cantidad],
                                                caliente: detalle[:caliente],
                                                precio: detalle[:precio],
                                                descuento: detalle[:descuento],
                                                promocion_id: detalle[:promocion_id],
                                                imei: detalle[:imei],
                                                cotizacion_id: detalle[:cotizacion_id],
                                                monto_cotizacion: detalle[:monto_cotizacion],
                                                moneda_id: detalle[:moneda_id],
                                                lote_id: @lote.id
                                                )
            end




            detalles.push(@detalle_venta)
          end

          medios = []
          if(not params[:venta][:venta_medios].nil?)
            params[:venta][:venta_medios].each do |medio_params|
              puts medio_params
              @medio_venta = VentaMedio.new(monto: medio_params[:monto],
                                            tarjeta_id: medio_params[:tarjeta_id],
                                            medio_pago_id: medio_params[:medio_pago_id])
              medios.push(@medio_venta)
            end
          end

          @venta.usuario_id = current_user_id
          @venta.venta_detalles = detalles

          puts 'detalles'
          puts detalles

          descuentoRedondeo = @venta.guardar(detalles, descuentoRedondeo)
          @ventas.push(@venta)
        end

        puts '@ventas tiene '
        puts @ventas.length
        puts 'elementos '
        puts @ventas

        puts 'medios originales tiene '
        puts medios.length
        puts 'elementos '
        puts medios

        ultima_venta = true
        venta_padre_id = @ventas[@ventas.length-1].id
        for @venta in @ventas
          #TODO: PARAMETRIZAR EL PRORRATEO DE MEDIOS DE PAGO.
          # SI EL PARAMETRO ES TRUE UTILIZAR BLOQUE *2 Y ELIMINAR EL BLOQUE *1

          #*1
          if @venta.id == venta_padre_id
            puts ">>>>>> GUARDANDO MEDIOS EN LA ULTIMA VENTA"
            venta_padre_id = @venta.id
            for medio in medios
              medio.venta_id = @venta.id
              medio.save!
            end
            #medios = @venta.guardarMedios(medios)
          else
            @venta.venta_padre_id = venta_padre_id
            puts ">>>>>> GUARDANDO VENTA PADRE #{venta_padre_id}"
            @venta.save
          end
          #*1

          #*2 UTILIZAR ESTO SI EL PARAMETRO ES FALSE
          #medios = @venta.guardarMedios(medios)
          #@venta.venta_padre_id = venta_padre_id
          #@venta.save
          #*2

          if @venta.id
            if soporta_cajas_impresion
              @venta.imprimir current_caja_impresion
            else
              puts '------------no se soporta caja de impresion---------------------'
            end

            genera_movimiento = Usuario.where("id = ? ",current_user).first.isAuthorized("BE_genera_movimientos_caja")
            puts "[VENTAS_CONTROLLER.RB][CAJA]#{current_caja}, venta: #{@venta},  moneda: #{@venta.moneda}] #{current_sucursal}"
            if(ParametrosEmpresa.default_empresa().first.soporta_cajas && genera_movimiento && !@venta.credito)
              Operacion.generarOperacion(current_caja.id, Settings.cajas.tipos_operaciones.venta, nil,
                                         @venta.id, @venta.total, @venta.moneda.id, current_sucursal)
            end
          end
        end

        @ventas[0]
      end
    end
  end


  def guardar(detalles, descuento_redondeo_general)
    transaction do
      if not uso_interno
        sucursal = Sucursal.find(sucursal_id)
        parametro = ParametrosEmpresa.by_empresa(sucursal.empresa_id).first
        if parametro.sequences_por_empresa
          empresa = Empresa.find(sucursal.empresa_id)
          nro_factura_tmp = empresa.get_next_nro_factura
          write_attribute(:nro_factura, nro_factura_tmp)
        else
          nro_factura_tmp = sucursal.get_next_nro_factura
          write_attribute(:nro_factura, nro_factura_tmp)
        end
      else
        nro_factura_tmp = '---'
      end

      c_total_sin_descuento = 0
      c_descuento_total = 0
      c_total = 0
      c_iva5 = 0
      c_iva10 = 0
      c_costo_total = 0

      venta_detalles.each do |det|
        det.venta = self
        subtotal_descuento = det.subtotal
        c_total_sin_descuento += det.subtotal_sin_descuento
        c_descuento_total += det.descuento
        c_costo_total += det.costo

        if det.producto.iva == 10
          c_iva10 += subtotal_descuento
        elsif det.producto.iva == 5
          c_iva5 += subtotal_descuento
        end
      end

      total_actual = c_total_sin_descuento - c_descuento_total
      descuento_redondeo_actual = 0
      descuento_actual = 0
      if c_descuento_total < c_total_sin_descuento
        if total_actual >= descuento_redondeo_general
          descuento_actual = c_descuento_total + descuento_redondeo_general
          total_actual = total_actual - descuento_redondeo_general
          descuento_redondeo_actual = descuento_redondeo_general
          descuento_redondeo_general = 0
        elsif total_actual < descuento_redondeo_general
          descuento_actual = c_total_sin_descuento
          descuento_redondeo_actual = total_actual
          descuento_redondeo_general = descuento_redondeo_general - total_actual
          total_actual = 0
        end
      end

      if moneda.redondeo
        write_attribute(:descuento_redondeo, descuento_redondeo_actual)
        write_attribute(:descuento, descuento_actual)
        write_attribute(:total, total_actual)
        write_attribute(:iva10, (c_iva10 / 11).round(0))
        write_attribute(:iva5, (c_iva5 / 21).round(0))
        write_attribute(:ganancia, (total_actual - c_costo_total).round(0))
      else
        write_attribute(:descuento_redondeo, descuento_redondeo_actual.round(2))
        write_attribute(:descuento, descuento_actual.round(2))
        write_attribute(:total, total_actual.round(2))
        write_attribute(:iva10, (c_iva10 / 11).round(2))
        write_attribute(:iva5, (c_iva5 / 21).round(2))
        write_attribute(:ganancia, (total_actual - c_costo_total).round(2))
      end
      #descuento_total = descuento_redondeo + c_descuento_total
      #total = c_total_sin_descuento - c_descuento_total
      #iva10 = (c_iva10 / 11).round(0)
      #iva5 = (c_iva5 / 21).round(0)

      if !save
        raise ActiveRecord::Rollback
      end

      if total == 0
        puts '=====venta con monto cero'
        observacion = "Venta #" + nro_factura_tmp
        Evento.venta_cero(observacion, usuario_id)
      end

      if descuento > 0
        puts '=====venta con monto cero'
        observacion = "Venta #" + nro_factura_tmp + " - Descuento: " + descuento.to_s
        Evento.aplicacion_descuento(observacion, usuario_id)
      end

      puts '=====venta detalles despues save'
      puts venta_detalles

      #if(credito)
      generarCuotas #se llama siempre a generar cuotas ahora, porque aunque sea al contado se puede llegar a generar cuotas dependiendo
      #del medio de pago
      #else
      #tipo = Settings.cajas.operaciones.credito
      #monto = total
      #observacion = 'CREACIÓN de Venta #' + nro_factura_tmp + '#'
      #SesionCaja.generarSesionCaja(tipo, monto, observacion, sucursal_id, fecha_registro)
      #end

      #obtener el depósito
      sucursal = Sucursal.find_by(id: sucursal_id)
      if sucursal
        puts "Sucursal #{sucursal.descripcion} - Deposito #{sucursal.deposito.descripcion}"
        deposito_id = sucursal.deposito_id
      else
        puts "ERROR: NO SE SELECCIONO NINGUNA SUCURSAL"
      end

      venta_detalles = detalles
      puts '=====venta detalles en guardar'
      puts venta_detalles

      venta_detalles.each do |detalle|
        begin
          puts 'guardando detalle'
          detalle.venta_id = id
          detalle.save!
          if (detalle.producto.tipo_producto.stock)
            Producto.actualizar_stock!(detalle.lote_id, deposito_id, -detalle.cantidad)
          end
        rescue ActiveRecord::RecordInvalid
          self.errors[:base] << "No existe stock suficiente en deposito para descontar el producto " + detalle.producto.descripcion
        end
      end
      if !self.errors[:base].empty?
        raise ActiveRecord::Rollback
      end
      descuento_redondeo_general
    end
  end

  def guardarMedios(medios)
    totalACubrir = total
    mediosSobrantes = []
    puts 'total a cubrir'
    puts totalACubrir

    while totalACubrir > 0 and medios.length > 0

      for medio in medios
        if (totalACubrir > 0)
          if (medio.monto < totalACubrir)
            totalACubrir = totalACubrir - medio.monto
            medio.venta_id = id
            medio.save!
          elsif (medio.monto == totalACubrir)
            totalACubrir = 0
            medio.venta_id = id
            medio.save!
          else
            medioDiferencia = VentaMedio.new(monto:  medio.monto - totalACubrir,
                                             tarjeta_id: medio.tarjeta_id,
                                             medio_pago_id: medio.medio_pago_id)
            mediosSobrantes.push(medioDiferencia)
            puts mediosSobrantes

            medio.monto = totalACubrir
            medio.venta_id = id
            medio.save!
            totalACubrir = 0
          end
        else
          mediosSobrantes.push(medio)
        end
      end
    end

    puts 'total a cubrir al final:'
    puts totalACubrir
    return mediosSobrantes
  end

  def imprimir(caja_imp)
    puts '---Dentro de Imprmir---'
    v = Venta.unscoped.find(self.id)
    if uso_interno
      pdf = UsoInternoReportPdf.new(v)
      codigo = 'interno'
    else
      pdf = FacturaReportPdf.new(v)
      codigo = sucursal.empresa.codigo
    end

    if caja_imp
      puts "-----------------se imprime usando la impresora de: " + codigo
      impresora = Impresora.where("tipo_documento=? AND caja_impresion_id=?", codigo, caja_imp.id).first
    end

    unless impresora
      #Si no se encuentra la impresora específica se usa la default
      puts "------------------no se encontró impresora y se vino por la default----------------"
      impresora = Impresora.where("tipo_documento='default'").first
    end
    begin
      PrinterService.new(impresora, pdf)
    rescue => e
      puts "======================================="
      logger.warn "Error al intentar imprimir: #{e}"
      puts "======================================="
    end

  end

  def eliminar
    transaction do
      #if(pagado)
      #tipo = Settings.cajas.operaciones.debito_venta
      #monto = total
      #observacion = 'ANULACIÓN de Venta #' + nro_factura + '#'
      #SesionCaja.generarSesionCaja(tipo, monto, observacion, sucursal_id, fecha_registro)

      #end

      #if(credito)
      #  generarCreditoCuotasPagadas()
      #end

      #obtener el depósito
      sucursal = Sucursal.find_by(id: sucursal_id)
      if sucursal
        deposito_id = sucursal.deposito_id
      end

      #Actualizar Stock por detalle
      @detalles = VentaDetalle.where("venta_id = ?", id)
      @detalles.each do |det|
        begin
          Producto.actualizar_stock!(det.lote_id, deposito_id, +det.cantidad)
        rescue ActiveRecord::RecordInvalid
          self.errors[:base] << "No existe stock suficiente en deposito para descontar"
        end
      end

      anulado = true
      deleted_at = Time.now
      save

      if !self.errors[:base].empty?
        raise ActiveRecord::Rollback
      end
    end
  end

  #creacion de cuotas
  def generarCuotas
    totalMasInteres = total
    fechaVencimiento = fecha_registro
    if credito
      if cantidad_cuotas >= 1
        tipoCredito = TipoCredito.find(tipo_credito_id)

        if tipoCredito
          update(deuda: totalMasInteres, pagado: false)

          if moneda.redondeo
            decimales = 0
          else
            decimales = 2
          end

          montoCuota = (totalMasInteres / cantidad_cuotas).round(decimales)

          diff = totalMasInteres - (montoCuota * cantidad_cuotas)

          puts tipoCredito.unidad_tiempo
          unidades = tipoCredito.unidad_tiempo.split('+')


          padding = unidades[1]
          if padding.nil?
            padding = 0
          else
            padding = padding.to_i
          end

          unidad = TipoCredito.unidades[unidades[0]]
          puts fechaVencimiento
          fechaVencimiento = fechaVencimiento + (padding * unidad)

          for i in 1..cantidad_cuotas
            puts "Venta cuota #{i}"

            fechaVencimiento = fechaVencimiento + (unidad * tipoCredito.plazo)
            puts "fecha vencimiento"
            puts fechaVencimiento

            if i == cantidad_cuotas and diff != 0
              montoCuota = (montoCuota + diff).round(decimales)
            end

            ventaCuota = VentaCuota.new(venta_id: id, nro_cuota: i,
                                        monto: montoCuota, fecha_vencimiento: fechaVencimiento,
                                        cancelado: false, estado: Settings.estadosCuotas.pendiente)
            ventaCuota.save
          end
        else
          puts "Advertencia, no existe el tipoCredito"
        end
      else
        puts "Advertencia, cantidad_cuotas incorrecta"
      end
    elsif medio_pago.registra_pago #se registra una cuota por más que sea al contado
      update(deuda: totalMasInteres, pagado: false)

      fechaVencimiento = fechaVencimiento + medio_pago.dias_hasta_pago.day
      ventaCuota = VentaCuota.new(venta_id: id, nro_cuota: 1,
                                  monto: totalMasInteres, fecha_vencimiento: fechaVencimiento,
                                  cancelado: false, estado: Settings.estadosCuotas.pendiente)
      ventaCuota.save
    end
  end


  def validate_venta
    total_sin_descuento = 0
    descuento_total = 0

    venta_detalles.each do |det|
      total_sin_descuento += det.precio * det.cantidad
      descuento_total += det.descuento
      puts 'detalleee'
      puts total_sin_descuento
    end

    descuento_modificado = !(total == total_sin_descuento - descuento_total)

    if !(precio_editable || supervisor.present?) && descuento_modificado
      errors.add(:base, "Los montos de la venta fueron editados sin autorización.")
    end
  end

  def deuda
    acumulado = 0
    if (not venta_cuotas.nil?)
      venta_cuotas.each do |cuota|
        acumulado = acumulado + cuota.pendiente
      end
    end
    return acumulado
  end

  def concepto_by_tipo
    puts "Obteniendo concepto by tipo: #{tipo_salida.codigo} + #{self.to_yaml}"
    if tipo_salida.codigo === "Campañas"
      return campanha.nil? ? "Sin campaña" : campanha.nombre

    elsif tipo_salida.codigo === 'Misiones'
      return campanha.nil? ? "Sin Misión": campanha.nombre

    elsif tipo_salida.codigo === "Donaciones"
      return cliente.nil? ? "Sin Cliente" : cliente.razon_social

    elsif tipo_salida.codigo === "Recetas"
      return paciente.nil? ? "Sin Paciente" : paciente.nombre + " " + paciente.apellido

    elsif tipo_salida.codigo === "Reposicion"
      return consultorio.nil? ? "Sin Consultorio" : consultorio.descripcion

    elsif tipo_salida.codigo === "Cirugias"
      return campanha.nil? ? "Sin Paciente p/ Cirugía" : paciente.nombre + " " + paciente.apellido

    elsif tipo_salida.codigo === "Consultorio"
      return consultorio.nil? ? "Sin Consultorio" : consultorio.descripcion

    elsif tipo_salida.codigo === "Clientes"
      return cliente.nil? ? "Sin Cliente" : cliente.razon_social

    elsif tipo_salida.codigo === "Pacientes"
      return paciente.nil? ? "Sin Paciente" : paciente.nombre + " " + paciente.apellido
    end
  end
end
