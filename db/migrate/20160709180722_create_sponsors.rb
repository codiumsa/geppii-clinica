class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.references :persona, index: true
      t.string :segmento

      t.timestamps
    end
  end
end
