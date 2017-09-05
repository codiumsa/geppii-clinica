// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Usuario = DS.Model.extend({
  nombre: DS.attr('string'),
  apellido: DS.attr('string'),
  email: DS.attr('string'),
  username: DS.attr('string'),
  password: DS.attr('string'),
  password_confirmation: DS.attr('string'),
  roles: DS.hasMany('rol', {async: true}),
  sucursales: DS.hasMany('sucursal', {async: true}),
  nombreCompleto: function  () {
    var nombreCompleto = this.get('nombre');
    if (this.get('apellido')) {
      nombreCompleto = nombreCompleto + this.get('apellido');
    }
    return nombreCompleto;
  }.property('nombre', 'apellido')

});
