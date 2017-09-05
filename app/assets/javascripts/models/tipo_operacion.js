// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.TipoOperacion = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string'),
  manual: DS.attr('boolean'),
  tieneCajaDestino: DS.attr('boolean'),
  cajaDestino: DS.belongsTo('caja',{async:true}),
  referencia: DS.attr('string'),
  caja_origen_default: DS.attr('string'),
  caja_destino_default: DS.attr('string'),
  muestraSaldo: DS.attr('boolean'),
  operacionBasica: DS.attr('boolean'),
  cajaDefault: DS.attr('string'),

  categorizable: function(){
    return this.get('operacionBasica') == false && this.get('manual') == true;
  }.property('categorizable'),
  externo: DS.attr('boolean')
});
