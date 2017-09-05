Bodega.ProductoDepositosIndexController = Ember.ArrayController.extend(
  Bodega.mixins.Pageable, 
  Bodega.mixins.Filterable,{
    perPage:  5,
    resource:  'productoDeposito',
    queryParams: ['producto'],
  	producto: null,
  	staticFilters: {
    	producto_activo: true
  	}
});