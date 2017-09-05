class CategoriaCliente < ActiveRecord::Base
  has_and_belongs_to_many :promociones
  has_many :categoria_cliente_promociones
  
  validates :nombre, :descripcion, presence: true
  scope :by_nombre, -> nombre { where("nombre ilike ?", "%#{nombre}%") }
  scope :by_all_attributes, -> value { where("descripcion ilike ? OR nombre ilike ?", 
          "%#{value}%", "%#{value}%")
  }
  scope :by_categoria_vigentes, -> categoria_cliente_id { joins(:promociones).where("categoria_clientes.id = ? and ? between promociones.fecha_vigencia_desde AND promociones.fecha_vigencia_hasta OR promociones.permanente = true", "#{categoria_cliente_id}", "#{Date.today()}") }

  scope :ids, lambda { |id| where(:id => id) }

  def guardar
    transaction do

      if !save
        raise ActiveRecord::Rollback
      end
      
      # promociones.each do |promocion|
      #   if promocion.exclusiva and (promocion.id?) 
      #     @clientePromocion = CategoriaClientePromocion.new(categoria_cliente_id: id,
      #                                   promocion_id: promocion.id)
      #     if !@clientePromocion.save
      #       raise ActiveRecord::Rollback
      #     end
      #   end
      # end
    end
  end
end
