Bodega.LoteDeposito = DS.Model.extend({
  lote: DS.belongsTo('lote',{ async: true }),
  deposito: DS.belongsTo('deposito',{ async: true }),
  contenedor: DS.belongsTo('contenedor',{ async: true }),
  cantidad: DS.attr('number'),
  descripcion: DS.attr('string'),
  loteIdAux: DS.attr('string')
});
