class AddEstadoToFichaCirugia < ActiveRecord::Migration
def change
    add_column :fichas_cirugia, :estado, :string
  end
end
