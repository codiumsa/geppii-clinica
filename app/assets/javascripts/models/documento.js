// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Documento = DS.Model.extend({
  tipoDocumento: DS.belongsTo('tipoDocumento', {embedded: 'always'}),
  nombre: DS.attr('string'),
  estado: DS.attr('string'),
  urlAdjunto: DS.attr('string'),
  adjuntoFileName: DS.attr('string'),
  adjuntoContentType: DS.attr('string'),
  adjuntoFileSize: DS.attr('string'),
  adjuntoUuid: DS.attr('string')
});
