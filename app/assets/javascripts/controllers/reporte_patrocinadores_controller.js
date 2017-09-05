Bodega.ReportePatrocinadoresIndexController = Ember.ArrayController.extend({
    formTitle: 'Reporte de Patrocinadores',

    actions: {
    search: function() {

        var self = this;
        var params = {};
        var tipoPatrocinador = this.get('tipoPatrocinador');
        var misionSeleccionada = this.get('misionSeleccionada');
        var downloadParams = {};
        downloadParams.httpMethod = 'GET';
        params.content_type = 'xls';
        params.tipo = 'reporte_patrocinadores';

        if(tipoPatrocinador){
            params.by_tipo_patrocinador = this.get('tipoPatrocinador');
        }
        if(misionSeleccionada){
            params.by_contacto_campanha = this.get('misionSeleccionada').get('id');
        }

        downloadParams.data = params
        Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
        Bodega.$.fileDownload("/api/v1/sponsors", downloadParams);



    }
  }
});