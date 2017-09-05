Bodega.Consultorio = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string'),
  especialidad: DS.belongsTo('especialidad')
});
