class AddDepositoToInventario < ActiveRecord::Migration
  def change
    add_reference :inventarios, :deposito, index: true
  end
end
