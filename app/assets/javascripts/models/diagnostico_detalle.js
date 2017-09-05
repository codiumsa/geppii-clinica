Bodega.DiagnosticoDetalle = DS.Model.extend({
  nombre: DS.attr('string'),
  tipo: DS.attr('string'),
  lado: DS.attr('string'),
  observacion: DS.attr('string'),
  localizacion: DS.attr('string'),
  resultadoSatisfactorio: DS.attr('boolean', { defaultValue: true }),
  satisfactorioClass: function() {
    if (this.get('resultadoSatisfactorio') != null) {
      if (!this.get('resultadoSatisfactorio')) {
        return "label label-danger label-mini";
      } else {
        return "label label-success label-mini";
      }
    } else {
      return "label label-info label-mini";
    }
  }.property('resultadoSatisfactorio'),
});