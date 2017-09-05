# encoding: utf-8
class ConyugueSerializer < ActiveModel::Serializer
  attributes :id, :nombre, :apellido, :nacionalidad, :cedula, :fecha_nacimiento, :lugar_nacimiento,
             :empleador, :actividad_empleador, :cargo, :profesion, :ingreso_mensual, :concepto_otros_ingresos, :otros_ingresos
end
