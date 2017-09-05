class ColaboradorSerializer < ActiveModel::Serializer
  attributes :id, :voluntario,:razon_social, :licencia,:nombre_club,:pals,:bls,:nombre_contacto_club,:email_contacto_club,:celular_contacto_club, :acreditado, :nombre_presidente_club, :correo_presidente_club, :celular_presidente_club,:comisionamiento, :tipo, :titulo, :institucion, :talle_remera, :lugar_trabajo_1,:lugar_trabajo_2,:lugar_trabajo_3, :horario_trabajo_1, :horario_trabajo_2, :horario_trabajo_3, :vencimiento_registro_medico, :vencimiento_bls, :vencimiento_pals, :otros
  has_one :persona,embed: :id, include: true
  has_one :tipo_colaborador, embed: :id, include: false
  has_one :especialidad, embed: :id, include: false
  has_many :campanhas_colaboradores, embed: :id, include: false, autosave: true
end
