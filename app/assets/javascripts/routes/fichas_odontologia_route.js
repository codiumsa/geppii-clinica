var praprarRecienNacido = function(controller) {
  var recienNacido = {};
  recienNacido.alimentacion = {
    pechoMaterno: null,
    biberon: null,
    SNG: null
  };
  recienNacido.rebordeAlveolar = {
    separacion: null,
    conformado: null
  };
  recienNacido.placaOrtopedica = null;
  recienNacido.otros = null;
  recienNacido.grafico = null;
  controller.set('recienNacido', recienNacido);
};

var prepararPreescolarAdolecente = function(controller) {
  var preescolarAdolescente = {};
  preescolarAdolescente.placaOrtopedica = { presente: null, tipo: null };
  preescolarAdolescente.higieneBucal = { presente: null, cantidadDiaria: null };
  preescolarAdolescente.odontologoRegular = null;
  preescolarAdolescente.estadoBucal = {
    caries: null,
    encias: null,
    obturaciones: null
  };
  controller.set('preescolarAdolescente', preescolarAdolescente);
};

var prepararExamenClinico = function(controller) {
  var examenClinico = {};
  examenClinico.tejidosBlandos = { intraorales: null, extraorales: null };
  examenClinico.ganglios = null;
  examenClinico.aspectoClinicoGral = null;
  examenClinico.antecedentesTratamientoDental = null;
  controller.set('examenClinico', examenClinico);
};

var prepararOdontograna = function(controller) {
  var odontograma = {}; //{id: "odntogramaId" };
  odontograma.superiorIzquierdo = [];
  odontograma.superiorDerecho = [];
  odontograma.inferiorIzquierdo = [];
  odontograma.inferiorDerecho = [];
  var i = 1;
  while (i <= 8) {
    odontograma.superiorIzquierdo.push({ id: '1' + String(9 - i), estado: null });
    odontograma.superiorDerecho.push({ id: '2' + String(i), estado: null });
    odontograma.inferiorDerecho.push({ id: '3' + String(i), estado: null });
    odontograma.inferiorIzquierdo.push({ id: '4' + String(9 - i), estado: null });
    i++;
  }
  //dientes de leche
  odontograma.lecheSuperiorIzquierdo = [];
  odontograma.lecheSuperiorDerecho = [];
  odontograma.lecheInferiorIzquierdo = [];
  odontograma.lecheInferiorDerecho = [];
  var li = 1;
  while (li < 6) {
    odontograma.lecheSuperiorIzquierdo.push({ id: '5' + String(6 - li), estado: null });
    odontograma.lecheSuperiorDerecho.push({ id: '6' + String(li), estado: null });
    odontograma.lecheInferiorDerecho.push({ id: '7' + String(li), estado: null });
    odontograma.lecheInferiorIzquierdo.push({ id: '8' + String(6 - li), estado: null });
    li++;
  }
  controller.set('odontograma', odontograma);
};

Bodega.FichasOdontologiaIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('fichaOdontologia', { page: 1 });
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

Bodega.FichaOdontologiaBaseRoute = Bodega.ClinicaBaseRoute.extend({
  setupController: function(controller, model, params) {
    this._super(controller, model, params, 'ODO');
    controller.recienNacido = null;
    controller.preescolarAdolescente = null;
    controller.examenClinico = null;
    controller.odontograma = null;
    //listas
    controller.tejidosBlandosIntraorales = null;
    controller.tejidosBlandosExtraorales = null;
    controller.gangliosLista = null;
    controller.aspectosClinico = null;
    controller.antecedentesTratamientos = null;
    //contenido listas
    controller.set('tejidosBlandosIntraorales', ['Normal', 'Gengivitis', 'Micosis', 'Ulceraciones']);
    controller.set('tejidosBlandosExtraorales', ['Simetrico', 'No Simetrico']);
    controller.set('gangliosLista', ['Normales', 'Inflamados', 'Hipertroficos']);
    controller.set('aspectosClinico', ['Bueno', 'Regular', 'Malo']);
    controller.set('antecedentesTratamientos', ['Hemorragias', 'Infecciones']);
    controller.set('estadosTratamiento', ['PENDIENTE', 'EN CURSO', 'CULMINADO']);
    //de alguna forma hay que dejar en la ficha la info de que
    //tratamientos tiene que hacerse.. y cargar en la consulta solo lo que se hizo..
    //seteo de estructuras json
    controller.set('detNuevo', this.store.createRecord('consultaDetalle'));
    var detalles = model.get('consultaDetalles');
    detalles.then(function(response) {
      console.log(response);
      controller.set('detalles', response);
    });
    
    if (model.get('recienNacido')) {
      controller.set('recienNacido', model.get('recienNacido'));
    } else {
      praprarRecienNacido(controller);
    }
    if (model.get('preescolarAdolescente')) {
      controller.set('preescolarAdolescente', model.get('preescolarAdolescente'));
    } else {
      prepararPreescolarAdolecente(controller);
    }
    if (model.get('examenClinico')) {
      controller.set('examenClinico', model.get('examenClinico'));
    } else {
      prepararExamenClinico(controller);
    }
    if (model.get('odontograma')) {
      controller.set('odontograma', model.get('odontograma'));
    } else {
      prepararOdontograna(controller);
    }

    controller.nuevoTratamiento = null;
    controller.listaDientes = null;
    controller.tratamientos = null; //lista de todos los tratamientos posibles, deberia venir de la bbdd
    controller.listTratamientos = []; //los tratamientos que se tiene que hacer para este paciente
    controller.set('nuevoTratamiento',
      Ember.Object.create({
        diente: null,
        tratamiento: null,
        estado: null,
        eliminado: false
      }));

    var a = '';
    a+= 'by_tipo_producto=T';
    a+= '&by_codigo_especialidad=' + 'ODO';
    a+= '&by_descripcion';
    console.log('Guardando queryScopeTratamientos: ', a);
    controller.set('queryScopeTratamientos', a);
    //crecion de lista de dientes para la tabla de tratamientos
    var listaDientes = [];
    Object.keys(controller.get('odontograma')).forEach(function(cuadranteKey) {
      var cuadrante = controller.get('odontograma')[cuadranteKey];
      Object.keys(cuadrante).forEach(function(dienteKey) {
        var diente = cuadrante[dienteKey];
        listaDientes.push({
          id: diente.id,
          nombre: diente.id
        });
      });
    });
    //TODO: ordenar de mayor a menor antes de agregar
    controller.set('listaDientes', listaDientes);
    controller.set('model', model);
  }
});

Bodega.FichasOdontologiaNewRoute = Bodega.FichaOdontologiaBaseRoute.extend({
  queryParams: {
    paciente_id: { replace: true }
  },

  model: function() {
    this.store.find('fichaOdontologia', { page: 1 });
    return this.store.createRecord('fichaOdontologia');
  },
  renderTemplate: function() {
    this.render('fichas_odontologia.new', {
      controller: 'fichasOdontologiaNew'
    });
  }
});


Bodega.FichaOdontologiaEditRoute = Bodega.FichaOdontologiaBaseRoute.extend({
  model: function(params) {
    return this.modelFor('fichaOdontologia');
  },
  renderTemplate: function() {
    this.render('fichas_odontologia.new', {
      controller: 'fichaOdontologiaEdit'
    });
  }
});
