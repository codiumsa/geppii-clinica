class AddCampanhaToVenta < ActiveRecord::Migration
  def change
    add_reference :ventas, :campanha, index: true
  end
end
