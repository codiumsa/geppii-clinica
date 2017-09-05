class AddTimestampsToFichasPsicologia < ActiveRecord::Migration
  def change
      add_column(:fichas_psicologia, :created_at, :datetime)
      add_column(:fichas_psicologia, :updated_at, :datetime)
  end
end
