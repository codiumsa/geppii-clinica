class AddSupervisorToVentas < ActiveRecord::Migration
  def change
    add_column :ventas, :supervisor, :string
  end
end
