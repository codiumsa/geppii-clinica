Bodega.ViajeColaborador = DS.Model.extend({
  viaje: DS.belongsTo('viaje', { async: true }),
  colaborador: DS.belongsTo('colaborador', { async: true }),
  observacion: DS.attr('string'),
  companhia: DS.attr('string'),
  costoTicket: DS.attr('number', {defaultValue: 0}),
  costoEstadia: DS.attr('number', {defaultValue: 0})
});
