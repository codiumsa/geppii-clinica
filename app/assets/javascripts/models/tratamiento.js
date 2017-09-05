// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Tratamiento = DS.Model.extend({
    nombre: DS.attr('string'),
    especialidad: DS.belongsTo('especialidad', {async: true})
    
});
