class AddConsultorioToVentas < ActiveRecord::Migration
  def change
    add_reference :ventas, :consultorio, index: true
  end
end
