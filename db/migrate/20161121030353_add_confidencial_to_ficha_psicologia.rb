class AddConfidencialToFichaPsicologia < ActiveRecord::Migration
  def change
    add_column :fichas_psicologia, :confidencial, :string
  end
end
