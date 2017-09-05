// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Sponsor = DS.Model.extend({
  persona: DS.belongsTo('persona', {embedded: 'always'}),
  ciRuc: DS.attr('string'),
  segmento: DS.attr('string'),
  activo: DS.attr('boolean'),
  idPersona: DS.attr('number'),
  contactoNombre: DS.attr('string'),
  contactoApellido: DS.attr('string'),
  contactoCelular: DS.attr('string'),
  razonSocial: DS.attr('string'),
  infoSponsor: DS.attr('string'),
  contactoCargo: DS.attr('string'),
  contactoEmail: DS.attr('string'),
  comprometido : DS.attr('string'),
  pagado : DS.attr('string'),
  tipoSponsor : DS.attr('string')
});
