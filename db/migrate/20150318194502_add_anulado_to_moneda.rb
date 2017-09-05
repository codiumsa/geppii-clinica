class AddAnuladoToMoneda < ActiveRecord::Migration
  def change
    add_column :monedas, :anulado, :boolean
  end
end
