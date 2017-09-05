// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Proveedor = DS.Model.extend({
  razonSocial: DS.attr('string'),
  infoProveedor: DS.attr('string'),
  ruc: DS.attr('string'),
  direccion: DS.attr('string'),
  telefono: DS.attr('string'),
  email: DS.attr('string'),
  personaContacto: DS.attr('string'),
  telefonoContacto: DS.attr('string')
});
