class AddProcesadoToInventarios < ActiveRecord::Migration
  def change
    add_column :inventarios, :procesado, :boolean, :default => false;  	
  end
end
