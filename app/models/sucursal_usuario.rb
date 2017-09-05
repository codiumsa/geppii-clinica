class SucursalUsuario < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :sucursal
  scope :by_usuario, -> usuario { where("usuario_id = ?", "#{usuario}") }
end