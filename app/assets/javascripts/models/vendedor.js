// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Vendedor = DS.Model.extend({
  nombre: DS.attr('string'),
  apellido: DS.attr('string'),
  direccion: DS.attr('string'),
  telefono: DS.attr('string'),
  email: DS.attr('string'),
  activo: DS.attr('boolean', {defaultValue: true}),
  sucursales: DS.hasMany('sucursal', {async: true}),
  comision: DS.attr('number', {defaultValue: 0}),
  
  nombreCompleto: function(){
    var nombre = this.get('nombre');
    var apellido = this.get('apellido');
    return nombre + ' ' + apellido;
  }.property('nombre')
});
