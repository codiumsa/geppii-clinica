// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Moneda = DS.Model.extend({
  nombre: DS.attr('string'),
  simbolo: DS.attr('string'),
  anulado: DS.attr('boolean', {defaultValue: false}),
  redondeo: DS.attr('boolean', {defaultValue: false}),
  guaranies: function(){
    if (this.get('simbolo') == "Gs."){
      return true;
    }else{
      return false;
    }
  }.property('credito'),
});
