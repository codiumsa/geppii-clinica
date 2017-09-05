class AddEmailToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :contacto_email, :string
  end
end
