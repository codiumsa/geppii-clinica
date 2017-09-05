class UpdateConsultas < ActiveRecord::Migration
  def change
        change_table :consultas do |c|
          c.change :receta, :text
          c.change :indicaciones, :text
        end
  end
end
