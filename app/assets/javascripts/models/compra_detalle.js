// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.CompraDetalle = DS.Model.extend({
  compra: DS.belongsTo('compra'),
  producto: DS.belongsTo('producto'),
  precio: DS.belongsTo('precio'),
  cantidad: DS.attr('number' ,{defaultValue: 1}),
  precioCompra: DS.attr('number'),
  precioVenta: DS.attr('number',{defaultValue: 0}),
  precioPromedio: DS.attr('number'),
  dirty: DS.attr('boolean', {defaultValue: false}),
  lote: DS.belongsTo('lote'),
  contenedor: DS.belongsTo('contenedor'),
  codigoLote:  DS.attr('string'),
  codigoContenedor:  DS.attr('string'),
  fechaVencimiento: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),

  
  subtotal: function(){
    var total = this.get('precioCompra') * this.get('cantidad');
    if(total){
      return total;
    }else{
      return 0;
    }
   
  
  }.property('cantidad', 'precioCompra'),

 fechaRegistro: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
 
});
