// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.TransferenciaDeposito = DS.Model.extend({
  origen: DS.belongsTo('deposito', { async: true }),
  destino: DS.belongsTo('deposito', { async: true }),
  usuario: DS.belongsTo('usuario', { async: true }),
  fechaRegistro: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
  detalle: DS.hasMany('transferenciaDepositoDetalle',{ async: true }),
  descripcion: DS.attr('string'),
  nroTransferencia: DS.attr('string')

});