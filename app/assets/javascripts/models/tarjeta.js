// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Tarjeta = DS.Model.extend({
  banco: DS.attr('string'),
  marca: DS.attr('string'),
  afinidad: DS.attr('string'),
  medioPago: DS.belongsTo('medioPago'),
  activo: DS.attr('boolean'),   

  displayName: function() {
    return this.get('banco') + ' - ' + this.get('marca') + ' - ' + this.get('afinidad');
  }.property('banco', 'marca', 'afinidad')
});
