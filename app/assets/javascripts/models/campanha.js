// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Campanha = DS.Model.extend({
  nombre: DS.attr('string'),
  descripcion: DS.attr('string'),
  misionesVinculo: DS.hasMany('misionVinculo'),
  estado: DS.attr('string'),
  persona: DS.belongsTo('persona', { async: true }),
  tipoCampanha: DS.belongsTo('tipoCampanha', { async: true }),
	campanhasColaboradores: DS.hasMany('campanhaColaborador', { async: true }),
  fechaIncio: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
  fechaFin: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  })
});
