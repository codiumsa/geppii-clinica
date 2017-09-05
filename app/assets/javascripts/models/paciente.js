// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Paciente = DS.Model.extend({
  persona: DS.belongsTo('persona' , {embedded: 'always'}),
  numeroPaciente: DS.attr('string'),
  observacion: DS.attr('string'),
  datosFamiliares: DS.attr('json'),
  contactoEmergencia: DS.attr('json'),
  vinculos: DS.attr('json'),
  otrosDatos: DS.attr('json'),
  anhos: DS.attr('number'),
  infoPaciente: DS.attr('string'),
  datosImportantes: DS.attr('json'),
  idPersona: DS.attr('number'),
  candidaturas: DS.hasMany('candidatura',{ async: true }),

});
