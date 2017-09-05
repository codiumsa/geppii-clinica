/*Handlebars.registerHelper('isAuthorized', function(recursoSolicitado, options) {

  if (Bodega.isAuthorized(recursoSolicitado, options)) {
    return options.fn(this);
  } else {
    return options.inverse(this);
  }
});*/
Handlebars.registerHelper('isAuthorized', function(recursoSolicitado, options) {
  var permisos = Ember.get(options.data.keywords.controller,'session.permisos');

  //Se vuelve a array los permisos en caso de que se haya vuelto cadena *un error cachiai*
  permisos = typeof permisos === "string" ? permisos.split(",") : permisos;
  permisos = permisos || [];

  recursos = typeof recursoSolicitado === "string" ? recursoSolicitado.trim().split(",") : recursoSolicitado; 
  recursos = recursos || [];
  //Se busca la coincidencia del recurso/accion.
  permitido = false;
  recursos.forEach(function(recurso){
    permisos.forEach(function(permiso){
		  if(permiso === recurso){
			 //console.log('Está autorizado al recurso ' + recurso);//eliminar
			 permitido = true;
       return;
		  }
    });
    if (permitido){
      return;
    }
  });

  if(permitido){
    return options.fn(this);
  }else{
    return options.inverse(this);    
  }
});