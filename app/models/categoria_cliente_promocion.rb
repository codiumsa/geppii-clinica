class CategoriaClientePromocion < ActiveRecord::Base
  belongs_to :categoriaCliente
  belongs_to :promocion

  scope :by_categoria_cliente, -> cat { where("categoria_cliente_id = ?", "#{cat}") }
  scope :ids, lambda { |id| where(:id => id) }
end
