class RegistroProduccion < ActiveRecord::Base
  #proceso, deposito, cantidad, estado, fecha, 
  belongs_to :proceso
  belongs_to :deposito
	validates :proceso, :cantidad, :estado, :deposito, presence: true


	scope :by_proceso_id, -> proceso_id { where("proceso_id = ?", "#{proceso_id}") }
  scope :by_deposito_id, -> deposito_id { where("deposito_id = ?", "#{deposito_id}") }
  scope :by_estado, -> estado { where("estado = ?", "#{estado}") }
  scope :by_observacion, -> observacion { where("observacion = ?", "#{observacion}") }
  scope :by_cantidad, -> cantidad { where("cantidad = ?", "#{cantidad}") }
  scope :by_fecha_before, -> before{ where("fecha_registro::date < ?", Date.parse(before)) }
  scope :by_fecha_on, -> on { where("fecha::date = ?", Date.parse(on)) }
  scope :by_fecha_after, -> after { where("fecha::date > ?", Date.parse(after)) }
  
  scope :by_all_attributes, -> value { 
    joins(:proceso).joins(:deposito)
    where("  registros_produccion.id = ?
    			OR registros_produccion.estado = ?
    			OR registros_produccion.observacion = ?
          OR registros_produccion.cantidad = ?

    			OR procesos.id = ? 
    			OR procesos.descripcion = ? 

    			OR depositos.id = ? 
    			OR depositos.descripcion like ?" ,
          number?(value) ? value.to_i : nil,
          "%#{value}%", "%#{value}%",
          number?(value) ? value.to_i : nil,
          number?(value) ? value.to_i : nil,
          "%#{value}%", 
          number?(value) ? value.to_i : nil,
          "%#{value}%")
  }
  def self.number? (string)
    true if Float(string) rescue false
  end  

  # ------------------------------------------------------------------------------------
  def iniciar (registroProduccion_params)
    puts ">>> >>> >>> INICIAR #{registroProduccion_params}"
    transaction do    
      proceso.proceso_detalles.each do |detalle|
        begin
          puts "Actualizando existencia #{detalle.producto_id} #{deposito_id} , #{-detalle.cantidad}"
          Producto.actualizar_stock!(detalle.producto_id, deposito_id, -detalle.cantidad)
        rescue ActiveRecord::RecordInvalid
          puts "... ... .... ... FALLO LA ACTUALIZACION"
          self.errors[:base] << "No existe stock suficiente de #{detalle.producto.descripcion}"
        end
      end

      if !self.errors[:base].empty?
        puts "... ... .... ... Lanzando excepcion"
        raise ActiveRecord::Rollback
      else
        puts "... ... .... ... Actualizando con update_attributes"
        if !update_attributes(registroProduccion_params)
          self.errors[:base] << "No se pudo modificar el registro de produccion."
          puts "... ... .... ... Haciendo Rollback"
          raise ActiveRecord::Rollback
        end
      end
    end
  end

  def terminar (registroProduccion_params)
    puts ">>> >>> >>> TERMINAR #{registroProduccion_params}"
    transaction do
        if !update_attributes(registroProduccion_params)
          self.errors[:base] << "Error al actualizar registro de produccion"
          puts "... ... .... ... Haciendo Rollback"
          raise ActiveRecord::Rollback
        end
        begin
        #producir producto
        puts "INTENTANDO TERMINAR EL PROCESO #{proceso.producto_id} #{deposito_id} #{cantidad}"
        Producto.actualizar_stock!(proceso.producto_id, deposito_id, cantidad)
        rescue ActiveRecord::RecordInvalid
          self.errors[:base] << "Error al persistir."
        end
    end
  end

  def eliminar
    puts ">>> >>> >>> ELIMINAR"
    transaction do
      errors = []
      
      if(estado==='REGISTRADO')
        destroy!
        return
      end
#ARREGLAR ESTO PRIMERO RESTAR Y DESPUES SUMAR LAS MATERIAS PRIMAS!!!D


      #descontar producto producido
      if(estado==='TERMINADO')
        begin
          Producto.actualizar_stock!(proceso.producto_id, deposito_id, -cantidad)
        rescue ActiveRecord::RecordInvalid
          self.errors[:base] << "No existe stock suficiente de #{proceso.producto.descripcion}"
        end
      end
      if self.errors[:base].empty?
        #devolver materia prima
        if(estado === 'INICIADO' or estado === 'TERMINADO')
          @detalles = ProcesoDetalle.where("proceso_id = ?", proceso_id)
          @detalles.each do |det|
            begin
              puts det.producto_id;
              Producto.actualizar_stock!(det.producto_id, deposito_id, det.cantidad)
            rescue ActiveRecord::RecordInvalid
              self.errors[:base] << "No existe stock suficiente de #{det.producto.descripcion}"
            end
            if !self.errors[:base].empty?
              raise ActiveRecord::Rollback
            end
          end
        end
        if self.errors[:base].empty?
          destroy!
        end
      end    
    end
  end

end
