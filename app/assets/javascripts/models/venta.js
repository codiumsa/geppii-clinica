// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Venta = DS.Model.extend({
  cliente: DS.belongsTo('cliente', { async: true }),
  tipoSalida: DS.belongsTo('tipoSalida', { async: true }),
  sucursal: DS.belongsTo('sucursal', { async: true }),
  campanha: DS.belongsTo('campanha', {async : true}),
  tipoCredito: DS.belongsTo('tipoCredito', { async: true }),
  colaborador: DS.belongsTo('colaborador', { async: true }),
  ventaDetalles: DS.hasMany('ventaDetalle',{ async: true }),
  ventaMedios: DS.hasMany('ventaMedio',{ async: true }),
  ventaCuota: DS.hasMany('ventaCuota',{ async: true }),
  descuento: DS.attr('number', {defaultValue: 0}),
  descuentoRedondeo: DS.attr('number', {defaultValue: 0}),
  total: DS.attr('number', {defaultValue: 0}),
  deuda: DS.attr('number', {defaultValue: 0}),
  iva10: DS.attr('number', {defaultValue: 0}),
  cantidadCirugias: DS.attr('number', {defaultValue: 0}),
  iva5: DS.attr('number', {defaultValue: 0}),
  ganancia: DS.attr('number', {defaultValue: 0}),
  credito: DS.attr('boolean', {defaultValue: false}),
  tarjetaCredito: DS.attr('boolean', {defaultValue: false}),
  vendedor: DS.belongsTo('vendedor', { async: true }),
  usoInterno: DS.attr('boolean', {defaultValue: false}),
  pagado: DS.attr('boolean', {defaultValue: true}),
  anulado: DS.attr('boolean', {defaultValue: false}),
  cirugia: DS.attr('boolean', {defaultValue: false}),
  cantidadCuotas: DS.attr('number', {defaultValue: 0}),
  nroFactura: DS.attr('string'),
  nombreCampanha: DS.attr('string'),
  nombreCliente: DS.attr('string'),
  persona: DS.belongsTo('persona', { async: true }),
  rucCliente: DS.attr('string'),
  supervisor: DS.attr('string'),
  moneda: DS.belongsTo('moneda', {async:true}),
  consultorio: DS.belongsTo('consultorio', {async:true}),
  medioPago: DS.belongsTo('medioPago', {async:true}),
  tarjeta: DS.belongsTo('tarjeta', {async:true}),
  porcentajeRecargo: DS.attr('number', {defaultValue: 0}),
  garante: DS.belongsTo('cliente', {async:true}),
  nroContrato: DS.attr('string', {async:true}),
  fechaRegistro: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),

  //Como internacionalizar cosas como esta?
  tipo: function(){
    if (this.get('credito')){
      return 'Crédito';
    }else{
      return 'Contado';
    }
  }.property('credito'),

  estado: function(){
    if (this.get('pagado')) {
      return 'Pagado';
    } else {
      return 'Pendiente de Pago';
    }
  }.property('pagado'),

  nroFacturaFormateado: function(){
    var nro = this.get('nroFactura');
    console.log(nro);
    if (nro === "" || nro == null) {
      return '---';
    } else {
      return nro;
    }
  }.property('nroFactura'),


});
