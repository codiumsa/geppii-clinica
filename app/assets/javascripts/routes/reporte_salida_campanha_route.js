Bodega.ReporteSalidaCampanhaIndexRoute = Bodega.AuthenticatedRoute.extend({
    queryParams: {
        tipo_salida: { refreshModel: true },
    },
    model: function(params) {
        console.log("Refreshing all models...", params);
        return null;
    },

    setupController: function(controller, model, params) {
        console.log("model", model, "params", params);
        controller.set('tipoSalida', params.queryParams.tipo_salida);
        controller.set('incluyeDetalle', false);
        controller.set('tipo_salida', params.queryParams.tipo_salida);

    }
});

Bodega.ReporteSalidaCampanha = Bodega.AuthenticatedRoute.extend({});