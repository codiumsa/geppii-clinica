// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Ciudad = DS.Model.extend({
  codigo: DS.attr('string'),
  nombre: DS.attr('string')
});
