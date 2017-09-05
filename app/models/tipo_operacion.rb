class TipoOperacion < ActiveRecord::Base
  self.table_name = "tipos_operacion"
  has_many :tipo_operacion_detalles, dependent: :destroy
  
  scope :unpaged, -> { order("id") }
  scope :by_codigo, -> codigo { where("codigo ilike ?", "#{codigo}") }
  scope :by_manual, -> { where("manual = true").order(operacion_basica: :desc, id: :asc) }
  scope :by_basica, -> { where("operacion_basica = true") }
  scope :by_categorizable, -> { where("operacion_basica = false and manual = true") }

  attr_accessor :tiene_caja_destino, :caja_origen_default, :caja_destino_default

  def self.by_manual_permitido (autorizado)
    if autorizado
      return self.by_manual
    else
      return self.by_manual.by_basica
    end
  end
    

  def tiene_caja_destino
    self.tipo_operacion_detalles.order(:secuencia).each do |detalle|
      if detalle.caja_destino 
          return true
      end
    end
    return false
  end

  def caja_origen_default
    if codigo === 'apertura'
      return 'sucursal'
    elsif codigo === 'cierre'
      return 'usuario'
    end
  end

  def caja_destino_default
    if codigo === 'apertura'
      return 'usuario'
    elsif codigo === 'cierre'
      return 'sucursal'
    end
  end
end
