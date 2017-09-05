class AddFieldsToSponsor < ActiveRecord::Migration
  def change
    add_column :sponsors, :contacto_nombre, :string
    add_column :sponsors, :contacto_apellido, :string
    add_column :sponsors, :contacto_celular, :string
    add_column :sponsors, :contacto_cargo, :string
  end
end
