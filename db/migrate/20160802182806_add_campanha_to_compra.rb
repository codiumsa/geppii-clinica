class AddCampanhaToCompra < ActiveRecord::Migration
  def change
    add_reference :compras, :campanha, index: true
    add_reference :compras, :sponsor, index: true
  end
end
