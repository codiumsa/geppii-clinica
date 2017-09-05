// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Sucursal = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string'),
  deposito: DS.belongsTo('deposito',{ async: true, defaultValue: null}),
  empresa: DS.belongsTo('empresa',{async: true, defaultValue: null}),
  vendedor: DS.belongsTo('vendedor',{async: true, defaultValue: null}),
  crearDeposito: DS.attr('boolean', {defaultValue: false}),
  color: DS.attr('string'),
  nuevaCaja: DS.belongsTo('caja',{async:true}),
  styleColor: function() {
   return "background:" + this.get('color');
  }.property('color')
});
