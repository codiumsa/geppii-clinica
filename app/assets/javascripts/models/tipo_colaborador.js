// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.TipoColaborador = DS.Model.extend({
  nombre: DS.attr('string'),
  descripcion: DS.attr('string'),
  tieneViajes: DS.attr('boolean'),
  esClub: DS.attr('boolean'),
  tieneLicencia: DS.attr('boolean'),
  nombreClub: function () {
    if(this.get('esClub') == true){
      return this.get('nombre') + " (Es club)";
    }else{
      return this.get('nombre');
    }
  }.property('esClub'),
});
