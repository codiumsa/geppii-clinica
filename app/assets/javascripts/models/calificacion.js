// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Calificacion = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string'),
  diasAtraso: DS.attr('number')
});
