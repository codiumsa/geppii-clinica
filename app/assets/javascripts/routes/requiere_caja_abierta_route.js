Bodega.RequiereCajaAbiertaRoute = Bodega.AuthenticatedRoute.extend({
    beforeModel: function(transition) {   
        var self = this;
        self.nextTransition = transition;

        var chequearCajaAbierta = function (self) {
        	var self = self;
        	var caja = self.store.find('caja', 'current_caja').then(function (current_caja) {
	        	var abierta = current_caja.get('abierta');
	        	//para que no se quede en la cache del store se hace el unload del record
	        	self.store.getById('caja', 'current_caja').unloadRecord();
	        	current_caja.unloadRecord();
	            if (!abierta) {
	                self.transitionTo('operaciones.new', {queryParams: {abierta: true, transition: self.nextTransition}});
	            }
	        });
        }

        //se consigue el parametro en cache
        var parametros = this.store.getById('parametrosEmpresa', 0);

        if (!parametros) {
        	//si no está en cache se trae del server
        	this.store.find('parametrosEmpresa', 'default').then(function (parametroDefault) {
        		//se crea un parametro en el store con id 0 para no traer del server cada vez
        		parametroDefault._data.id = 0;
        		self.store.createRecord('parametrosEmpresa', parametroDefault._data);
	        	if (parametroDefault.get('soportaCajas')) {
	        		chequearCajaAbierta(self);
	        	}
	        });
        } else {
        	if (parametros.get('soportaCajas')) {
        		chequearCajaAbierta(self);
        	}
        }
    }
});