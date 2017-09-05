class AddRedondeoToMoneda < ActiveRecord::Migration
  def change
    add_column :monedas, :redondeo, :boolean, :default => false
  end
end
