class AddAnuladoToVentas < ActiveRecord::Migration
  def change
    add_column :ventas, :anulado, :boolean, :default => false
    add_column(:ventas, :deleted_at, :datetime)

  end
end
