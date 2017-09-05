class AddNumeroChequeToPago < ActiveRecord::Migration
  def change
    add_column :pagos, :numero_cheque, :string
  end
end
