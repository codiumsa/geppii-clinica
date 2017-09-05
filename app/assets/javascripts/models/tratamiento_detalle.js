Bodega.TratamientoDetalle = DS.Model.extend({
  nombre: DS.attr('string'),
  tipo: DS.attr('string'),
  observacion: DS.attr('string'),
  hospital: DS.attr('string'),
  anhoMision: DS.attr('string'),
  campanha: DS.attr('string'),
  resultadoSatisfactorio: DS.attr('boolean', { defaultValue: true }),
  externo: DS.attr('boolean', { defaultValue: false }),
  estadoTratamiento: DS.attr('string'),
  lugar: DS.attr('string'),

  realizadoEn: function() {
    console.log("this",this);
    if (this.get('externo')) {
      this.set('lugar', this.get('hospital'));
    } else {
      if (this.get('campanha')) {
        var self = this;
        var mision = this.store.find('campanha', this.get('campanha'));
        mision.then(function(data) {
          self.set('lugar', data.get('nombre'));
          console.log(data.get('fechaIncio'));
          // self.set('anhoMision', data.get('fechaIncio').getFullYear());
        });
      } else {
        this.set('lugar', this.get('hospital'));
      }
    }

  }.property('lugar', 'campanha', 'hospital'),

  claseEstado: function() {
    if (this.get('estadoTratamiento') == 'Recomendado') {
      return "label label-danger label-mini";
    } else {
      return "label label-info label-mini";
    }
  }.property('estadoTratamiento'),
});
