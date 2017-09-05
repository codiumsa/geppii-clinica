class AddPersonaToVentas < ActiveRecord::Migration
  def change
    add_reference :ventas, :persona, index: true
  end
end
