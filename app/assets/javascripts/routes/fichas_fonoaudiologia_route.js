/* configuracion de los objetos json para hacer binding en los handlebars*/

var prepararComunicacionLenguaje = function(controller) {
  //TODO: define exactly how this is going to be handled
  var comunicacionLenguaje = {};
  comunicacionLenguaje.etapas = [];
  /* Etapa pre Linguistica */
  var edadPrelinguistica1 = {edad:'0-3 Meses'};
  edadPrelinguistica1.expresiones= ['Mira a los ojos y la boca del interlocutor',
			   'Precursores de forma: llanto: Gritos',
			   'Llanto con valor comunicativo',
			   {'Sonidos vegetativos': [
			     'Bosteza',
			     'Arrullos',
			     'Suspiros',
			     'Fricaciones']},//sublista
			   'Gorjeo',
			   'Sonríe y expresa emociones (ante enojo,' +
			   'tristeza, sorpresa y susto)',
			   'Intención comunicativa'];

  edadPrelinguistica1.comprensiones =
    ['Busca con la vista la fuente de los sonidos que escucha',
     'Detiene actividad ante sonido',
     'Reacciona ante ruidos del entorno',
     'Presenta sonrisa social producida ante conversación con el adulto',
     'Mantiene contacto visual'];

  var edadPrelinguistica2 = {edad: '6-9 Meses'};
  edadPrelinguistica2.expresiones =
    ['Responde con vocalizaciones cuando se le llama por su nombre',
     'Utiliza “no” gestualmente, mueve la cabeza'];

  edadPrelinguistica2.comprensiones =
    ['Responde con gesto apropiado a palabras como “ven”, “upa”, “abrazo”',
     'Reconoce nombre de objetos comunes',
     'Se detiene ante el “no"'];

  var edadPrelinguistica3 = {edad:'9–12 Meses'};

  edadPrelinguistica3.expresiones =
    ['Juego con emisión lingüística',
     'Usa oraciones cortas, como expresiones de cuatro o más '+
     'silabas, sin palabras verdaderas (con entonación)',
     'Intenta imitar nuevas palabras (al observar imágenes)',
     'Intenta obtener objetos usando voz, señalización, y gesto',
     'Posee un lenguaje verbal-gestual',
     'Juego libre (juegos de encaje)'];

  edadPrelinguistica3.comprensiones = [{'Precursores del contenido':
					['Atención a sonidos',
					 'Atención voz materna',
					 'Búsqueda fuente sonora']},
			      'Fijación  mirada',
			      'Atiende cuando lo llaman por su nombre',
			      'Entiende preguntas simples como ¿Dónde está la pelota?',
			      'Ejecuta ordenes simples, acompañado de gesto',
			      'Obedece ordenes simples como “guarda el cubo en la caja”',
			      'Realiza onomatopeyas ante figura de animales comunes',
			      'Memoria visual “tres pares”'];

  comunicacionLenguaje.etapas.push({name: "Pre Linguistica",
				    value: [edadPrelinguistica1, edadPrelinguistica2, edadPrelinguistica3]});

  /* Fin Etapa pre Linguistica */
  /* Etapa Linguistica */
  var edadLinguistica1 = {edad:'12-18 Meses'};
  edadLinguistica1.expresiones = ['Realiza movimientos corporales al ritmo de la música',
				  'Imita movimientos de la terapeuta',
				  'Imita secuencias musicales con un instrumento',
				  'Control del tono e intensidad al hablar',
				  'Emite holofrases como “papa”, “guau”',
				  'Responde “si” “no”',
				  'Conoce el nombre de sus padres',
				  'Agrupa sonidos y silabas repetidas a voluntad como “yuyu” = yogurt',
				  'Pide cosas por su nombre',
				  'Nominación de objetos comunes',
				  'Los categoriza',
				  'Describe una imagen (usar cuentos con imágenes)',
				  'Juego libre. Encaja y reconoce formas y colores'];

  edadLinguistica1.comprensiones = ['Parece entender estados de ánimo del hablante',
				     'Deja lo que está haciendo para escuchar un sonido',
				     'Puede entregar un objeto cuando se le pide',
				     'Reconoce varias partes de su cuerpo (nombrar)',
				     'Reconoce los miembros de la familia',
				    'Compresión de ordenes simples de un elemento, '+
				    'Dame, toma, ven, siéntate, busca, coloca, adentro, saca, guarda',
				     'Identifica cosas por su uso',
				     'Agrupa objetos por categoría',
				     'Identifica objetos por su nombre',
				     'Sobre-extensión semántica'];
  var edadLinguistica2 = {edad: '18-24 Meses'};
  edadLinguistica2.expresiones = ['Posee vocabulario de 50 palabras o más',
				  'Enunciado de dos palabras',
				  'Usa NO',
				  {'Usa interrogativos': ['Que','Donde','Como','Por qué','Cuando','Para que']},
				  'Dice su nombre',
				  'Conoce el nombre de sus padres',
				  'Describe lo que sucede en una imagen',
				  'Nombra 10 partes del cuerpo',
				  'Usa algunos pronombres',
				  'Combina palabras en oraciones simples como “papa ven”, “aquí esta”',
				  'Función instrumental: (peticiones, permiso y ayuda)',
				  'Función reguladora (respuestas y saludos)',
				  'Función interactiva: (pedir información “que”)',
				  'Función personal (función imaginativa, asociada',
				  +' a juego simbólico utilizando artículos de la cocina, muñecos….)',
				  'Juego libre'];

 edadLinguistica2.comprensiones = ['Comprende pronombres personales como “mío” tuyo”',
				   'Comprende oraciones complejas',
				   'Comprende acciones verbales',
				   'Identifica ordenes simples y complejas: “saca”, “toma eso y guárdalo dentro de la caja”',
				   'Identifica objetos por su nombre',
				   {'Nociones de tamaño': ['Grande','Chico']},
				   {'Noción espacial': ['Arriba', 'Abajo', 'Adentro','Afuera']},
				   {'Reconoce': ['bonito','Feo']},
				   'Busca el objeto al cambiarlo de lugar'];
  comunicacionLenguaje.etapas.push(
    {name: 'Linguistica',
     value: [edadLinguistica1, edadLinguistica2]});

/* Fin Etapa Linguistica */
  controller.set('comunicacionEtapas', comunicacionLenguaje.etapas);
};

var prepararAlimentacion = function(controller){

  //en este objeto se guardan todos los datos recolectados
  //si es una edicion este objeto deberia venir como parametro
  var alimentacion = {};
  alimentacion.condicionClinica = {condicion: null, observaciones: null};
  alimentacion.frecuenciaRespiratoria = {frecuencia: null, observaciones: null};
  alimentacion.sectorOrofacial = {reflejos: {busqueda: null,
					     succion: null,
					     deglucion: null},
				  observaciones: null};

  alimentacion.morfologiaOsea = null;

  alimentacion.morfologiaMuscular = {labio: null,
					lengua:{
					  tipo: null,
					  forma: null,
					  tamanho: null},
					observaciones: null};
  alimentacion.frenilloLingual = {frenillo: null, observaciones: null};
  alimentacion.viaDeAlimentacion = null;
  alimentacion.tipoLactancia = null;
  alimentacion.viaDeAlimentacion = {
    noDigestiva: {tipo: null,
		  fechaDeAlimentcionConSonda: null,
		  SOG: null,
		  SNG: null,
		  bomba: null,
		  gavages: null,
		  goteoOjeringa: null,
		  frecuenciaYcantidad: null,
		  posturaDeAlimentacion: null},
    viaOral: {lactanciaMaterna: {tuvo: null,
				 eclusiva: null,
				 hastaCuando: null,
				 frecuencia: null},
	      mamadera:{tuvo: null,
			tipoTetina: null,
			cuando: null,
			frecuencia: null,
			incorporoSemisolidos: null,
			incorporoSolidos: null,
			dificultades: null,
			cantidad: null,
			cuandoIncorporoSemisolidos: null,
			cuandoIncorporoSolidos: null
		       }
	     }
  };
  alimentacion.coordinacion = {respiracionDeglucion: null,
			       liquidos: null,
			       semiliquidos: null,
			       solidos: null};
  alimentacion.fechaDeAlimentcionConSonda = null;
  controller.set('alimentacion', alimentacion);
};

var prepararFistula = function(controller){
  var fistula =  {};
  fistula.svg = '';
  fistula.dimension = null;
  fistula.ubicacion = null;
  fistula.labio = {completo: null,
		  operado:  null,
		  bilateral: null};
  fistula.paladar =  {completo: null,
		     operado:  null};
  fistula.ubicacionPalatal = {anterior: null,
		     transicion: null,
		      posterior: null};
  fistula.paladarBlando = {uvulaBifida: null,
			   longitud: null,
			   motricidad: null,
			   insercionMusculoElevador: null};
  fistula.labio2= {sellado: null, tono: null, morfologia: null,
		   motricidad: null}; //?
  fistula.lengu = {frenillo: null, tono: null, motricidad: null};
  fistula.regurgitacionNasal = null;
  fistula.dificultadSocial = null;
  fistula.quejaEscolar = null;
  fistula.fonoterapia = null;
  controller.set('fistula',fistula);
};

//por falta de tiempo: se ponen los valores a ser presentados como asi
//la seleccion en el mismo objeto
var prepararEstimulos = function(controller){
  controller.set('estimulos', [
    {nombre:'inteligibilidadDdelHabla', valor:null,
     titulo: 'Inteligibilidad del Habla – Habla Conversacional', valores: [
       'Dentro de límites normales: El habla es siempre fácil de entender',
       'Leve: El habla es ocasionalmente difícil de entender',
       'Moderada: El habla es frecuentemente difícil de entender',
       'Severa: El habla es difícil de entender la mayor parte del tiempo',
       'No evaluable']},
    {nombre:'hiponasalidad',
     valor:null,
     titulo: 'Hiponasalidad – Oraciones', valores: [
       'Dentro de límites normales/Ausente',
       'Presente',
       'No evaluable']},
    {nombre:'hipernasalidad', valor:null,
     titulo: 'Hipernasalidad – Oraciones', valores: [
       'Dentro de límites normales',
       'Leve',
       'Moderada',
       'Severa',
       'No evaluable']},
    {nombre: 'desordenDeVoz', valor:null,
     titulo: 'Desorden de voz – En toda la muestra de habla', valores: [
       'Dentro de límites normales/Ausente',
       'Presente',
       'No evaluable']},
    {nombre: 'emisionesNasalesAudibles', valor:null,
     titulo: 'Emisiones Nasales Audibles y/o Turbulencia Nasal – Oraciones', valores: [
       'Dentro de límites normales/Ausente',
       'Ocasional',
       'Frecuente',
       'No evaluable']},
    {nombre:'produccionDeConsonantes', valor:null,
     subItems: true, //TODO: - tiene sub items que completar
     titulo: 'Errores en la Producción de Consonantes- Oraciones', valores: [
       'Dentro de límites normales/Ausente',
       'Errores del desarrollo fonológico/articulatorio',
       'No evaluable'
     ],
     subEstimulos: [
       {nombre: 'Retroceso anormal a un lugar post uvular',
	valores: [{id: 0,
		   nombre: 'Faríngeo [ħ, ʕ]',
		   valor: ''}]},
       {nombre:'Retroceso anormal pero permaneciendo en un lugar oral',
	valores: [{id: 0, nombre: 'Medio-dorsopalatal', valor: null},
		  {id: 1, nombre:'Velar /t d s n l/[k ɡ x ŋ', valor: null},
		  {id: 2, nombre:'Uvular /t d s n l/[q Gχɴ]', valor: null},
		  {id: 3, nombre:'Fricativa Nasal [m̥͋] [n̥͋] [ŋ̥͋]', valor: null},
		  {id: 4, nombre: '(Si se presenta cualquiera de las dos, marque 1)'
		   +' - Consonante nasal por consonante oral de presión /b, d, g/[m, n, ŋ]'
		   +' - Nasalización de consonantes de presión sonoras [b̃] [d̃] [ɡ̃]',
		   valor: null},
		  {id: 5, nombre: 'Baja presión en consonantes de presión [b ͉d ͉ɡ͉t ͉f ͉]', valor: null},
		  {id: 6, nombre: 'Otras alteraciones:'
		   +' - Palatización/palatal: [ tʲ ], [ç ʝ]'
		   +' - Lateralización/Lateral: [sˡ] [tˡ] or[ ɬ ] [ls]'
		   +' - Dentalización/inter-dentalización: [t̪] [t̪͆]',
		   valor: null}
		 ]},
     ]},
    {nombre:'aceptabilidadDelHabla', valor:null,
     titulo: 'Aceptabilidad del Habla – En toda la muestra de Habla', valores: [
       'Dentro de límites normales/Ausente: El habla es normal',
       'Leve: Desviaciones del habla en grado normal a leve',
       'Moderada: Desviaciones del habla en grado normal a moderado',
       'Severa: Desviaciones del habla en grado normal a severo',
       'No evaluable']}
  ]);
};

var preprarFonoAudiologia = function(controller){
  prepararComunicacionLenguaje(controller);
  prepararAlimentacion(controller);
  prepararFistula(controller);
  prepararEstimulos(controller);
};

var prepararListasEstaticas = function(controller){
  controller.set('coordinacionesPresentes', ['Nunca', 'Ocasional', 'Frecuente', 'Anteriormente']);
  controller.set('condicionesClinicas', ['Somnolencia', 'Dormido', 'Alerta', 'Excitado']);
  controller.set('frecuenciasRespiratorias', ['Normal', 'Bradipnea', 'Taquipnea']);
  controller.set('labios', ['normotonicos', 'hipotonicos', 'hipertonicos']);
  controller.set('lenguaTipos', ['elevada', 'descendida', 'protruida', 'retraida']);
  controller.set('lenguaFormas', ['normal', 'ensanchada sin punta', 'marcas en laterales']);
  controller.set('lenguaTamanhos', ['normal', 'macroglosia', 'microglosia']);
  controller.set('frenillosLinguales', ['normal', 'corto']);
  controller.set('viasDeAlimentacion', ['parenteral', 'enteral']);
  controller.set('tipoLactancias', ['Exclusiva', 'Parcial']);

  controller.set('fistulaDimensiones', ['Mínima (< 2mm)',
					'Pequeño (2-5mm)',
					'Medio (5-8mm)',
					'Grande (> 8mm)']);
  controller.set('fistulaUbicaciones', ['Alveolar', 'Palatal']);

  controller.set('fistulaLongitudes', ['Ningun Cambio',
				       'Satisfactorio',
				       'Aparentemente Corto']);
  controller.set('fistulaMotricidades', ['Ningun Cambio',
					 'Feria',
					 'No satisfactorio']);
  controller.set('insercionesMusculoElevador', ['Aparentemente Adecuada',
						  'Aparentemente Inadecuada']);
  controller.set('regurgitacionesNasales', ['Ausente', 'Ocasional', 'Frecuente']);
  controller.set('fonoterapias', ['Nunca', 'Una o mas consultas',
				  'Interrumpida', 'En proceso', 'Concluida']);
};
/* fin de la configuracion */

Bodega.FichaFonoaudiologiaBaseRoute = Bodega.ClinicaBaseRoute.extend({
  setupController: function(controller, model, params) {
    this._super(controller, model, params, 'FON');

    //inicializar objetos json
    //set all this into one object? ficha_fonoaudiologia
    controller.fistulaDimensiones = null;
    controller.fistulaUbicaciones = null;
    controller.fistulaLongitudes = null;
    controller.fistulaMotricidades = null;
    controller.insercionesMusculoElevador = null;
    controller.regurgitacionesNasales = null;
    controller.fonoterapias = null;
    controller.mostraSubestimulos = null;
    //
    controller.comunicacionEtapas = null;
    controller.condicionesClinicas = null;
    controller.frecuenciasRespiratorias = null;
    controller.labios = null;
    controller.lenguaTipos = null;
    controller.lenguaFormas = null;
    controller.lenguaTamanhos = null;
    controller.frenillosLinguales = null;
    controller.viasDeAlimentacion = null;
    controller.tipoLactancias = null;
    controller.alimentacion = null;
    controller.coordinacionesPresentes = null;
    controller.estimulos = null;
    controller.fistula = {};
    prepararListasEstaticas(controller);

    // if (params && params.queryParams.paciente_id){
      //si el id viene como parametro no existe ficha fonoaudiologia para
      //este paciente
      // var paciente = this.store.createRecord('paciente');
      // paciente.set('id', params.queryParams.paciente_id);
      // model.set('paciente', paciente);
      //
      // var pacienteActual = this.store.find('paciente', {by_id: params.queryParams.paciente_id});
      // pacienteActual.then(function(response){
      //   controller.set('pacienteActual', pacienteActual.objectAt(0));
      //   console.log('PACIENTE ACTUAL: ', pacienteActual.objectAt(0));
      // });
    //   preprarFonoAudiologia(controller);
    // }else{
      // var pacienteActual = model.get('paciente');
      // pacienteActual.then(function(response){
      //   controller.set('pacienteActual', response);
      //   console.log('PACIENTE ACTUAL: ', response);
      // });
      if(model.get('comunicacionLenguaje')){
      	controller.set('comunicacionEtapas', model.get('comunicacionLenguaje'));
      }else{
      	prepararComunicacionLenguaje(controller);
      }
      if(model.get('estimulos')){
	       model.get('estimulos').forEach(function(estimulo){
	          //harcodeado para mostrar la lista de subitems
	           if (estimulo.nombre == 'produccionDeConsonantes') {
               if (estimulo.valor !== null && estimulo.valor === 'Errores del desarrollo fonológico/articulatorio') {
                 controller.set('mostraSubestimulos', true);
              } else {
                controller.set('mostraSubestimulos', false);
            }
          }
	      });
	       controller.set('estimulos', model.get('estimulos'));
      }else{
	       prepararEstimulos(controller);
      }

      if(model.get('alimentacion')){
      	controller.set('alimentacion', model.get('alimentacion'));
      }else{
      	prepararAlimentacion(controller);
      }
      if(model.get('fistula')){
      	controller.set('fistula', model.get('fistula'));
      }else{
      	prepararFistula(controller);
      }
    controller.set('model', model);
  }
});

Bodega.FichasFonoaudiologiaIndexRoute = Bodega.AuthenticatedRoute.extend({
  model: function() {
    return this.store.find('fichaFonoaudiologia', {page:1});
  },
  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('currentPage', 1);
  }
});

//Bodega.FichaFonoaudiologiaRoute = Bodega.AuthenticatedRoute.extend({});
Bodega.FichaFonoaudiologiaEditRoute = Bodega.FichaFonoaudiologiaBaseRoute.extend({
  model: function(params) {
    return this.modelFor('fichaFonoaudiologia');
  },
  renderTemplate: function() {
    this.render('pacientes.fonoaudiologia.principal', {
      controller: 'fichaFonoaudiologiaEdit'
    });
  }
});

Bodega.FichasFonoaudiologiaNewRoute = Bodega.FichaFonoaudiologiaBaseRoute.extend({
  queryParams: {
    paciente_id: {replace: true}
  },
  model: function() {
    this.store.find('fichaFonoaudiologia', {page:1});
    var model = this.store.createRecord('fichaFonoaudiologia');
    return model;
  },
  renderTemplate: function() {
    this.render('pacientes.fonoaudiologia.principal', {
      controller: 'fichasFonoaudiologiaNew'
    });
  }
});
