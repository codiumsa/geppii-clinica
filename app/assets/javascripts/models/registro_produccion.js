// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.RegistroProduccion = DS.Model.extend({
  proceso: DS.belongsTo('proceso'),
  deposito: DS.belongsTo('deposito'),
  cantidad: DS.attr('number'),
  estado: DS.attr('string'),
  observacion: DS.attr('string'),
  fecha: DS.attr('isodate', {
      defaultValue: function() {
        return moment().toDate();
      }
  }),

  	isIniciado: function() {
		return this.get('estado') === 'INICIADO';
	}.property('estado'),
	isRegistrado: function() {
			return this.get('estado') === 'REGISTRADO';
	}.property('estado'),
	isTerminado: function() {
			return this.get('estado') === 'TERMINADO';
	}.property('estado'),
	isEditable: function() {
			return this.get('estado') === 'INICIADO' || this.get('estado') === 'TERMINADO';
	}.property('estado')
	
});
