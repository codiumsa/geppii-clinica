// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Persona = DS.Model.extend({
  tipoPersona: DS.attr('string'),
  ciRuc: DS.attr('string'),
  razonSocial: DS.attr('string'),
  nombre: DS.attr('string'),
  apellido: DS.attr('string'),
  direccion: DS.attr('string'),
  barrio: DS.attr('string'),
  ciudad: DS.belongsTo('ciudad',{async:true}),
  telefono: DS.attr('string'),
  celular: DS.attr('string'),
  estadoCivil: DS.attr('string'),
  fechaNacimiento: DS.attr('date'),
  correo: DS.attr('string'),
  sexo: DS.attr('string'),
  numeroHijos: DS.attr('number'),
  edad: DS.attr('number'),
  estudiosRealizados: DS.attr('string'),
  nacionalidad: DS.attr('string'),
  tipoDomicilio: DS.attr('string'),
  antiguedadDomicilio: DS.attr('number'),
  conyugue: DS.belongsTo('conyugue', {embedded: 'always'}),
  esTipoPersonaJuridica: function () {
    return this.get('tipoPersona') == "Jurídica";
  }.property('tipoPersona'),

  razonSocialIndex: function () {
    if (!this.get('razonSocial')) {
      return this.get('nombre') + " " + this.get('apellido');
    }else {
      return this.get('razonSocial');
    }
  }.property('razonSocial'),
});
