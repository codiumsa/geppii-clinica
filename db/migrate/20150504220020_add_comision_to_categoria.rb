class AddComisionToCategoria < ActiveRecord::Migration
  def change
  	add_column :categorias, :comision, :float, :default => 0.0
  end
end
