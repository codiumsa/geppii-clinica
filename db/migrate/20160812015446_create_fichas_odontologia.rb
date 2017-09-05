class CreateFichasOdontologia < ActiveRecord::Migration
  def change
    create_table :fichas_odontologia do |t|

      t.timestamps
    end
  end
end
