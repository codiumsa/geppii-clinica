class AddBlsToColaboradores < ActiveRecord::Migration
  def change
    add_column :colaboradores, :bls, :string
    add_column :colaboradores, :pals, :string
  end
end
