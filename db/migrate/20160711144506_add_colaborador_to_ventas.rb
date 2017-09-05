class AddColaboradorToVentas < ActiveRecord::Migration
  def change
    add_reference :ventas, :colaborador, index: true
  end
end
