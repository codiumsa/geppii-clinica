// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.TipoContacto = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string'),
  conCampanha: DS.attr('boolean', {defaultValue: false}),
  conMision: DS.attr('boolean', {defaultValue: false}),
  activo: DS.attr('boolean', {defaultValue: false})
});
