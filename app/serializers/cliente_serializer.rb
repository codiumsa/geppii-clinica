# encoding: utf-8
class ClienteSerializer < ActiveModel::Serializer
  attributes :id, :numero_cliente, :antiguedad, :salario_mensual, :matricula_nro, :ramo, :otros_ingresos, :activo,
    :empleador, :jubilado, :comerciante, :pariente1, :pariente2, :ingreso_pariente2, :domicilio, :cargo,
    :telefono, :institucion, :empleado, :profesion, :actividad_empleador, :direccion_empleador,
    :barrio_empleador, :fecha_pago_sueldo, :concepto_otros_ingresos, :ips, :fecha_ingreso_informconf, :fecha_egreso_informconf, :info_cliente, :razon_social_cliente,
    :id_persona
  has_one :persona,embed: :id, include: true
  has_one :calificacion,embed: :id, include: false
  has_many :referencias, embed: :id, include: false
  has_many :ingreso_familiares, embed: :id, include: false
  has_many :documentos, embed: :id, include: true
end
