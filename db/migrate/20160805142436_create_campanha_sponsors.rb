class CreateCampanhaSponsors < ActiveRecord::Migration
  def change
    create_table :campanha_sponsors do |t|
      t.references :campanha, index: true
      t.references :sponsor, index: true
      t.timestamps
    end
  end
end
