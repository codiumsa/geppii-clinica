class AddTipoSponsorToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :tipo_sponsor, :string
  end
end
