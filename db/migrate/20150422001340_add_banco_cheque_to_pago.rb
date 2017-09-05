class AddBancoChequeToPago < ActiveRecord::Migration
  def change
    add_column :pagos, :banco_cheque, :string
  end
end
