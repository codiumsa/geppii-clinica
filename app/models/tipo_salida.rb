class TipoSalida < ActiveRecord::Base

  scope :by_codigo, -> codigo {where("codigo ilike ?","#{codigo}")}

end
