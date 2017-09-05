// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Conyugue = DS.Model.extend({
  nombre: DS.attr('string'),
  apellido: DS.attr('string'),
  direccion: DS.attr('string'),
  nacionalidad: DS.attr('string'),
  cedula: DS.attr('string'),
  fechaNacimiento: DS.attr('date'),
  lugarNacimiento: DS.attr('string'),
  empleador: DS.attr('string'),
  actividadEmpleador: DS.attr('string'),
  cargo: DS.attr('string'),
  profesion: DS.attr('string'),
  ingresoMensual: DS.attr('number'),
  conceptoOtrosIngresos: DS.attr('string'),
  otrosIngresos: DS.attr('number')
});
