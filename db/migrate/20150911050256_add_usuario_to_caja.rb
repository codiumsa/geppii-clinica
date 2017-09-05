class AddUsuarioToCaja < ActiveRecord::Migration
  def change
    add_reference :cajas, :usuario, index: true
  end
end
