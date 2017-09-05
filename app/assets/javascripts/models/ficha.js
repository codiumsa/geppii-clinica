Bodega.Ficha = DS.Model.extend({
  colaborador: DS.belongsTo('colaborador', { async: true }),
  paciente: DS.belongsTo('paciente', { async: true }),
  // campanha: DS.belongsTo('campanha', { async: true }),
  fechaConsultaInicial: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
  updatedAt: DS.attr('isodate'),
  estado: DS.attr('string'),
  nroFicha: DS.attr('number'),
  consultaId: DS.attr('number')
});
