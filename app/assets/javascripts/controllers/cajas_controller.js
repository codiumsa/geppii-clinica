Bodega.CajasIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable, {
  resource:  'caja'
});

Bodega.CajasNewController = Ember.ObjectController.extend({

  formTitle: 'Nueva Caja',
  
  tiposCaja: [{nombre: "Usuario", id: "U"},
  {nombre: "Otra", id: "O"}],

  tipoDefault: {nombre: "Otra", id: "O"},
  // tipoSeleccionado: {nombre: "Otra", id: "O"},

  mostrarUsuarios: function(){
    self = this;
    tipoSeleccionado = this.get('tipoSeleccionado');
    // console.log('tipoSeleccionado');

    if (tipoSeleccionado && tipoSeleccionado.id == "U" ){
      console.log(tipoSeleccionado.id);
      self.set('habilitaUsuarios',true);
      console.log(self.get('habilitaUsuarios'));
    }
    else {
      // self.set('tipoSeleccionado','O');
      self.set('habilitaUsuarios',false);
      console.log(self.get('habilitaUsuarios'));
    }
  }.observes('tipoSeleccionado'),

  mostrarSucursales: function(){
    self = this;
      empresaSeleccionada = this.get('empresaSeleccionada');
      console.log("Mostar sucursales");
      console.log(empresaSeleccionada);
      if(empresaSeleccionada){
        this.store.find('sucursal', {'by_empresa' : empresaSeleccionada.get('id')}).then(function(response){ 
          self.set('sucursales', response);
          self.set('sucursalDefault', response.objectAt(0));
          self.set('sucursalSeleccionada', response.objectAt(0));
        });
      }

  }.observes('empresaSeleccionada'),

  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      // var sucursal = this.get('sucursalSeleccionada');
      console.log('usuarioo');
      console.log(self.get('usuarioSeleccionado'));
      // model.set('sucursal', sucursal);
      model.set('saldo',0);
      if(self.get('habilitaUsuarios')){
       model.set('usuario',self.get('usuarioSeleccionado'));
       console.log(model.get('usuario'));
       model.set('tipoCaja','U');
      }
      else{
        console.log("no entro habilitaUsuarios")
        model.set('tipoCaja','O');
      }
      if(self.get(''))
        model.save().then(function(response) {
        // success
        self.transitionToRoute('cajas');
      }, function(response){
        // error
      });
    },

    cancel: function() {
      var model = this.get('model');
      this.transitionToRoute('cajas');
    }
  }
});

Bodega.CajaEditController = Ember.ObjectController.extend({

  formTitle: 'Editar Caja',

  tiposCaja: [{nombre: "Otra", id: "O"}],
  tiposCaja: [{nombre: "Usuario", id: "U"},
  {nombre: "Otra", id: "O"}],
  
  actions: {
    save: function() {
      var model = this.get('model');
      var self = this;
      
      model.save().then(function(response) {
        //success
        self.transitionToRoute('cajas');
      }, function(response) {
        //error
        model.rollback();
      });
    },

    cancel: function() {
      this.transitionToRoute('cajas');
    }
  }
});

Bodega.CajaDeleteController = Ember.ObjectController.extend({

  actions: {
    deleteRecord: function() {
			$('body').removeClass('modal-open');
      var model = this.get('model');
      var self = this;
      model.deleteRecord();
      model.save().then(function() {
        self.transitionToRoute('cajas');
      });
    },

    cancel: function() {
			$('body').removeClass('modal-open');
      this.transitionToRoute('cajas');
    }
  }
});