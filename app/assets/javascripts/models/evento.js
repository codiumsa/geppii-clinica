// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Evento = DS.Model.extend({
  tipo: DS.attr('string'),
  observacion: DS.attr('string'),
  fecha: DS.attr('date')
});
