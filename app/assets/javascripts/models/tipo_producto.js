Bodega.TipoProducto = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string'),
  usaLote: DS.attr('boolean', {defaultValue: false}),
  procedimiento: DS.attr('boolean', {defaultValue: false}),
  especialidad: DS.attr('boolean', {defaultValue: false}),
  stock: DS.attr('boolean', {defaultValue: false}),
  usaLote: DS.attr('boolean', {defaultValue: false}),
  productoOsi: DS.attr('boolean', {defaultValue: false}),


  servicio: function(){
  		return this.get('codigo') ==='S';
  }.property('codigo'),

  set: function(){
      return this.get('codigo') ==='SET';
  }.property('codigo'),

  tratamiento: function(){
      return this.get('codigo') ==='T';
  }.property('codigo'),

  medicamento: function(){
  		return this.get('codigo') === 'M';
  }.property('codigo'),

  inkind: function(){
  		return this.get('codigo') === 'I';
  }.property('codigo'),

  equipo: function(){
      return this.get('codigo') === 'EQ';
  }.property('codigo'),

  mueble: function(){
      return this.get('codigo') === 'MUE';
  }.property('codigo'),

  muebleEquipo: function(){
      return (this.get('codigo') === 'MUE' || this.get('codigo') === 'EQ');
  }.property('codigo'),

  producto: function(){
  		return this.get('codigo') === 'P';
  }.property('codigo'),

  servicioMueble: function(){
      return (this.get('codigo') === 'S' || this.get('codigo') === 'EQ' || this.get('codigo') === 'MUE');
  }.property('codigo'),

  necesitaReceta: function(){
      return (this.get('codigo') === 'M' || this.get('codigo') === 'D');
  }.property('codigo')


});
