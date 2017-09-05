Bodega.ReporteOperacionIndexController = Ember.ArrayController.extend({
  formTitle: 'Operaciones por Caja',

  loadCategorias: function() {
    var tipoOperacionSeleccionada = this.get('tipoOperacionSeleccionada');
    var self = this;

    if (tipoOperacionSeleccionada && tipoOperacionSeleccionada.get('categorizable')) {
        var categoriaOperaciones = this.store.find('categoriaOperacion', 
            {'unpaged' : true, 'by_activo' : true, 'by_tipo_operacion': tipoOperacionSeleccionada.get('id')}
        );

        categoriaOperaciones.then(function() {
            self.set('categoriaOperaciones', categoriaOperaciones);
            self.set('categoriaOperacionSeleccionada', null);
        });
    }
    else {
        //console.log('loadSucursal: tipoOperacionSeleccionada null');
    }
}.observes('tipoOperacionSeleccionada'),
    
  actions: {
    search: function() {
      var self = this;
      var params = {};
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      params.tipo = 'reporte_operaciones';

			var fechaDespues = this.get('fecha_despues');
      var fechaAntes = this.get('fecha_antes');
      var fechaDia = this.get('fecha_dia');

      if(this.get('cajaSeleccionada')){
        params.by_cajas_id = this.get('cajaSeleccionada').get('id');
      }

      if(this.get('tipoOperacionSeleccionada')){
        params.by_tipo_operacion = this.get('tipoOperacionSeleccionada').get('id');
        if(this.get('categoriaOperacionSeleccionada')){
          params.by_categoria_operacion = this.get('categoriaOperacionSeleccionada').get('id');
        }
      }
      if(this.get('fecha_antes')){
        params.by_fecha_before = this.get('fecha_antes');
      }
      if(this.get('fecha_despues')){
        params.by_fecha_after = this.get('fecha_despues');
      }
      if(this.get('fecha_dia')){
        params.by_fecha_on = this.get('fecha_dia');
      }

      if(fechaAntes && fechaDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaDespues && fechaDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaAntes && fechaDia && fechaDespues){
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
      }else if (fechaDespues && fechaAntes && (fechaDespues.getTime()>fechaAntes.getTime())){
        Bodega.Notification.show('Error','Seleccione un rango de fechas válido',Bodega.Notification.ERROR_MSG);
      }else{
        Bodega.Notification.show('Éxito', 'Creado correctamente');
        downloadParams.data = params;
        Bodega.$.fileDownload("/api/v1/operaciones", downloadParams);
      }        
    }
  }
});