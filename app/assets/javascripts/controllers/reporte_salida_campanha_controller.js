Bodega.ReporteSalidaCampanhaIndexController = Ember.ArrayController.extend({
    formTitle: 'Reporte de Salidas por',
    queryParams: ['tipo_salida'],
    tipo_salida: null,

    campanhas: Ember.computed('tipo_salida', function() {
        return this.get('tipo_salida') === 'Campañas&Misiones';
    }),
    consultorios: Ember.computed('tipo_salida', function() {
        return this.get('tipo_salida') === 'Consultorio&Reposicion';
    }),

    actions: {
        search: function() {

            var self = this;
            var params = {};
            var fechaDespues = this.get('fecha_inicio_despues');
            var fechaAntes = this.get('fecha_inicio_antes');
            var fechaDia = this.get('fecha_inicio_dia');
            var downloadParams = {};
            var descripcion = this.get('descripcion');
            var nombre = this.get('nombre');
            var incluye_detalle = this.get('incluyeDetalle');

            downloadParams.httpMethod = 'GET';
            params.content_type = 'pdf';
            params.tipo = 'reporte_salidas_campanha';
            params.tipo_salida = this.get('tipo_salida')

            if (this.get('campanhaSeleccionada') != null && nombre != null) {
                params.by_campanha_id = this.get('campanhaSeleccionada').get('id');
            }
            if (this.get('consultorioSeleccionado') != null && descripcion != null) {
                params.by_consultorio_id = this.get('consultorioSeleccionado').get('id');
            }
            if (incluye_detalle) {
                params.incluye_detalle = incluye_detalle
            }
            if (this.get('fecha_inicio_despues')) {
                params.by_fecha_registro_after = this.get('fecha_inicio_despues');
            }
            if (this.get('fecha_inicio_antes')) {
                params.by_fecha_registro_before = this.get('fecha_inicio_antes');
            }
            if (this.get('fecha_inicio_dia')) {
                params.by_fecha_registro_on = this.get('fecha_inicio_dia');
            }
            if (fechaAntes && fechaDia) {
                Bodega.Notification.show('Error', 'Seleccione un rango de fechas válido', Bodega.Notification.ERROR_MSG);
            } else if (fechaDespues && fechaDia) {
                Bodega.Notification.show('Error', 'Seleccione un rango de fechas válido', Bodega.Notification.ERROR_MSG);
            } else if (fechaAntes && fechaDia && fechaDespues) {
                Bodega.Notification.show('Error', 'Seleccione un rango de fechas válido', Bodega.Notification.ERROR_MSG);
            } else if (fechaDespues && fechaAntes && (fechaDespues.getTime() > fechaAntes.getTime())) {
                Bodega.Notification.show('Error', 'Seleccione un rango de fechas válido', Bodega.Notification.ERROR_MSG);
            } else {
                downloadParams.data = params;
                Bodega.Notification.show('Descarga.', 'El reporte se descargará.');
                Bodega.$.fileDownload("/api/v1/ventas", downloadParams);
            }

            this.set('campanhaSeleccionada', null);
            this.set('consultorioSeleccionado', null);
            this.set('nombre', '');
            this.set('descripcion', '');
        }
    }

});