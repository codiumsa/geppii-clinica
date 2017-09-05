/* configuracion de los objetos json para hacer binding en los handlebars*/

var prepararFichaNutricion = function() {
  //TODO: define exactly how this is going to be handled
  var preguntas = [];
  preguntas.pushObject(Ember.Object.create({ key: "¿QUÉ ALIMENTOS ESTÁ RECIBIENDO?", value: null }));
  preguntas.pushObject(Ember.Object.create({ key: "¿ALERGIA A ALGÚN ALIMENTO?", value: null }));
  preguntas.pushObject(Ember.Object.create({ key: "¿TOMA ALGÚN MEDICAMENTO?", value: null }));
  preguntas.pushObject(Ember.Object.create({ key: "¿SUPLEMENTOS VITAMÍNICOS?", value: null }));
  preguntas.pushObject(Ember.Object.create({ key: "¿FECHA ÚLTIMA DESPARAZITACIÓN?", value: null }));

  var recordatorio = [];
  recordatorio.pushObject(Ember.Object.create({ key: "DESAYUNO", value: null }));
  recordatorio.pushObject(Ember.Object.create({ key: "MEDIA MAÑANA", value: null }));
  recordatorio.pushObject(Ember.Object.create({ key: "ALMUERZO", value: null }));
  recordatorio.pushObject(Ember.Object.create({ key: "MERIENDA", value: null }));
  recordatorio.pushObject(Ember.Object.create({ key: "CENA", value: null }));
  recordatorio.pushObject(Ember.Object.create({ key: "COLACIÓN", value: null }));
  var controles = [];

  var datos = {};
  datos.preguntas = preguntas;
  datos.recordatorios = recordatorio;
  datos.controles = controles;
  return datos;
};
/* fin de la configuracion */

Bodega.FichaNutricionBaseRoute = Bodega.ClinicaBaseRoute.extend({
  setupController: function(controller, model, params) {
    this._super(controller, model, params, 'NUT');
    if (model.get('datos')) {
      console.log('---------------> Seteando datos del modelo:', model.get('datos'));
      controller.set('datosDto', model.get('datos'));
      if(controller.get('datosDto') && !controller.get('datosDto').controles){
        controller.get('datosDto').controles = [];
      }
    } else {
      console.log('---------------> Seteando datos nuevos, tiene modelo.....');
      controller.set('datosDto', prepararFichaNutricion());
    }

    controller.set('controlNuevo', Ember.Object.create({
      fecha: null,
      edad: null,
      peso: null,
      talla: null,
      pc: null,
      pe: null,
      te: null,
      imc: null,
      evolucion: null,
      eliminado: false
    }));

    controller.set('model', model);
  }
});

Bodega.FichasNutricionIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('fichaNutricion', { page: 1 });
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.FichaNutricionEditRoute = Bodega.FichaNutricionBaseRoute.extend({
  model: function(params) {
    return this.modelFor('fichaNutricion');
  },
  renderTemplate: function() {
    this.render('fichas_nutricion.new', {
      controller: 'fichaNutricionEdit'
    });
  }
});

Bodega.FichasNutricionNewRoute = Bodega.FichaNutricionBaseRoute.extend({

  model: function() {
    this.store.find('fichaNutricion', { page: 1 });
    var model = this.store.createRecord('fichaNutricion');
    return model;
  },
  renderTemplate: function() {
    this.render('fichas_nutricion.new', {
      controller: 'fichasNutricionNew'
    });
  }
});
