// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.TipoSponsor = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string')
});
