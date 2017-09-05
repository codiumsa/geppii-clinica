class Viaje < ActiveRecord::Base
  has_many :viaje_colaboradores, :dependent => :destroy
  validates :descripcion, presence: true

  scope :by_colaborador_id, -> colaborador_id {joins(:viaje_colaboradores).where("viaje_colaboradores.colaborador_id = ?", colaborador_id)}
  scope :by_descripcion, -> descripcion { where("descripcion ilike ?", "%descripcion%") }
  scope :by_id, -> id { where("id = ?", id ) }
  scope :by_fecha_after, -> after{ where("fecha_inicio::date > ?", Date.parse(after)) }
  scope :by_fecha_before, -> before{ where("fecha_fin::date < ?", Date.parse(before)) }
  scope :by_fecha_on, -> on{ where("fecha_inicio::date = ?", Date.parse(on)) }
  scope :by_lugar, -> lugar { where("destino ilike ?", "%#{lugar}%") }
  

  def valorizacion
    unless self.viaje_colaboradores.blank?
      return self.viaje_colaboradores.map{|c| c.costo_ticket + c.costo_estadia}.inject(:+)
    else
      return 0
    end
  end

end
