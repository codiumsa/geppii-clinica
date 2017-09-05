Bodega.ReporteInventariosIndexController = Ember.ArrayController.extend({
    
  formTitle: 'Reporte de Inventarios',
  routeIsReadyForAction: false,

  controlCheck: function(){
    var self = this;
    controlInventario = this.get('controlInventario');

    if(typeof controlInventario === 'undefined' || controlInventario == false){
      self.set('inventariosTemp',self.get('inventarios'));
      self.set('control',false);

    }else{
      self.set('inventariosTemp',self.get('inventariosControl'));
      self.set('selectedInventario', self.get('inventariosTemp').objectAt(0))
      self.set('control',true);

    }
  }.observes('controlInventario'),

  actions: {
    search: function() {
             
      var self = this;
      var params = {};
      var downloadParams ={};
      downloadParams.httpMethod = 'GET';
      params.content_type = 'pdf';
      controlInventario = this.get('controlInventario');
      lengthControl = this.get('inventariosControlLength');

      var fechaInicioDespues = this.get('fecha_inicio_despues');
      var fechaInicioAntes = this.get('fecha_inicio_antes');
      var fechaInicioDia = this.get('fecha_inicio_dia');

      var fechaFinDespues = this.get('fecha_fin_despues');
      var fechaFinAntes = this.get('fecha_fin_antes');
      var fechaFinDia = this.get('fecha_fin_dia');

      var fecha_inicio = false;
      var fecha_fin = false;

      if(typeof controlInventario === 'undefined'){
        controlInventario = false;
      }

      if(this.get('fecha_inicio_antes')){
        params.by_fecha_inicio_before = this.get('fecha_inicio_antes');
      }
      if(this.get('fecha_inicio_despues')){
        params.by_fecha_inicio_after = this.get('fecha_inicio_despues');
      }
      if(this.get('fecha_inicio_dia')){
        params.by_fecha_inicio_on = this.get('fecha_inicio_dia');
      }

      if(this.get('fecha_fin_antes')){
        params.by_fecha_fin_before = this.get('fecha_fin_antes');
      }
      if(this.get('fecha_fin_despues')){
        params.by_fecha_fin_after = this.get('fecha_fin_despues');
      }
      if(this.get('fecha_fin_dia')){
        params.by_fecha_fin_on = this.get('fecha_fin_dia');
      }
      if(this.get('selectedDeposito')){
        params.by_deposito_id = this.get('selectedDeposito').get('id');
      }

      if(fechaInicioAntes && fechaInicioDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de inicio válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaInicioDespues && fechaInicioDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de inicio válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaInicioAntes && fechaInicioDia && fechaInicioDespues){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de inicio válido',Bodega.Notification.ERROR_MSG);
      }else if (fechaInicioDespues && fechaInicioAntes && (fechaInicioDespues.getTime()>fechaInicioAntes.getTime())){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de inicio válido',Bodega.Notification.ERROR_MSG);
      }else{
        fecha_inicio = true;
      }    

      if(fechaFinAntes && fechaFinDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de fin válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaFinDespues && fechaFinDia){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de fin válido',Bodega.Notification.ERROR_MSG);
      }else if(fechaFinAntes && fechaFinDia && fechaFinDespues){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de fin válido',Bodega.Notification.ERROR_MSG);
      }else if (fechaFinDespues && fechaFinAntes && (fechaFinDespues.getTime()>fechaFinAntes.getTime())){
        Bodega.Notification.show('Error','Seleccione un rango de fechas de fin válido',Bodega.Notification.ERROR_MSG);
      }else{
        fecha_fin = true;   
      }   

      if(fecha_inicio && fecha_fin){
        if(!controlInventario){
          if(typeof this.get('selectedInventario') === 'undefined' || this.get('selectedInventario') == null){
            downloadParams.data = params
            Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
            Bodega.$.fileDownload("/api/v1/inventarios", downloadParams);    
            }else{
              params.by_id = this.get('selectedInventario').get('id');
              downloadParams.data = params
              Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
              Bodega.$.fileDownload("/api/v1/inventarios", downloadParams);  
            }
          }else if(lengthControl == 0 && controlInventario){
            Bodega.Notification.show('Error','Seleccione un Inventario Válido',Bodega.Notification.ERROR_MSG);
          }else if(lengthControl > 0 && controlInventario){
            params.by_id = this.get('selectedInventario').get('id');;
            downloadParams.data = params
            Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
            Bodega.$.fileDownload("/api/v1/inventarios", downloadParams);  
          }
      }
    }
        
        
  }
    
});