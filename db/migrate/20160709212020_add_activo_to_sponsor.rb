class AddActivoToSponsor < ActiveRecord::Migration
  def change
    add_column :sponsors, :activo, :boolean
  end
end
