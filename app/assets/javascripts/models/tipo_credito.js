// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.TipoCredito = DS.Model.extend({
  descripcion: DS.attr('string'),
  plazo: DS.attr('number'),
  unidadTiempo: DS.attr('string'),

  unidadTiempoFormateado: function () {
	var unidadesTiempo = {
				"D": "Días", 
                "W": "Semanas",
                "M": "Meses",
                "M+1": "Meses (primera cuota en 1 mes)", 
                "M+2": "Meses (primera cuota en 2 meses)", 
                "M+3": "Meses (primera cuota en 3 meses)"};
    return unidadesTiempo[this.get('unidadTiempo')];
  }.property('unidadTiempo')

});
