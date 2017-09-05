// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Proceso = DS.Model.extend({
  producto: DS.belongsTo('producto',{ async: true }),
  cantidad: DS.attr('number'),
  descripcion: DS.attr('string'),
  estado: DS.attr('string'),
  procesoDetalle: DS.hasMany('procesoDetalle' ,{ async: true }),
  isCancelado: function() {
		return this.get('estado') === 'CANCELADO';
	}.property('estado'),
  isVigente: function() {
      return this.get('estado') === 'VIGENTE';
    }.property('estado'),
});
