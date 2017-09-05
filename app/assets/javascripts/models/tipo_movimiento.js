// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.TipoMovimiento = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string'),
  
  credito: function(){
  		return this.get('codigo') ==='C';
  }.property('codigo'),
  debito: function(){
  		return this.get('codigo') === 'D';
  }.property('codigo')
});
