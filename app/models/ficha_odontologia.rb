class FichaOdontologia < ActiveRecord::Base
  belongs_to :paciente
  scope :paciente_id, -> value{
    where("paciente_id = ?", "#{value}" )
      .order(created_at: :desc).limit(1)}
  attr_accessor :consulta_detalles
  def consulta_detalles
    return ConsultaDetalle.where("id_ficha = ?", id)
  end
end
