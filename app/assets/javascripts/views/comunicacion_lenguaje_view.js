//vistas necesarias para fonoaudiologia
Bodega.views = Bodega.views || {};
//TODO:
//Adaptar para que reciba objetos json ya estructurados
Bodega.views.ComunicacionLenguajeView = Ember.View.extend({
  templateName: 'pacientes/fonoaudiologia/comunicacion_lenguaje'
});

var prepararValores = function (listaInicial){
  var resultado = [];
  listaInicial.forEach(function(item){
    if(typeof(item) == 'string'){ //
      resultado.push({name: item, value: null});
    }else if(typeof(item) == 'object'){
      //si es una lista son subitems
      //TODO: datos de la base de datos con anidacion
      var key = Object.keys(item)[0];
      var value = item[Object.keys(item)[0]];
      //if(value && value.length !== undefined){
      if(Array.isArray(value)){
	//nested call
	resultado.push({lista: true,
			name: key,
			value: prepararValores(value)});
      }else{
	resultado.push(item);
	//resultado.push({name: key, value: value});
      }
    }
  });
  return resultado;
};

Bodega.views.ComunicaionEtapasView = Ember.View.extend({
  templateName: 'pacientes/fonoaudiologia/template_etapa',
  setEdades: function() {
    var edades =  Ember.get(this, 'edades');
    if(edades){
      var newEdades = [];
      edades.forEach(function(edad){
	if(edad){
	  edad.expresiones = prepararValores(edad.expresiones);
	  edad.comprensiones = prepararValores(edad.comprensiones);
	  newEdades.push(edad);
	}
      });
      this.set('edades', newEdades);
    }
  },
  didInsertElement: function() {
    this.setEdades();
    if (Ember.get(this, 'autofocus')) {
      this.$().focus();
    }
  }
});

