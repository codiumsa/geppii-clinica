// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Inventario = DS.Model.extend({
  fechaInicio: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
  fechaFin: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),
  descripcion: DS.attr('string'),
  control: DS.attr('boolean'),
  deposito: DS.belongsTo('deposito', {async: true}),
  usuario: DS.belongsTo('usuario', {async: true}),
  inventarioLote: DS.hasMany('inventarioLote',{ async: true }),
  correcto: DS.attr('boolean'),
  procesado: DS.attr('boolean')

});
