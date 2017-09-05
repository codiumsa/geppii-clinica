class CursoColaborador < ActiveRecord::Base
  belongs_to :curso
  belongs_to :colaborador

end
