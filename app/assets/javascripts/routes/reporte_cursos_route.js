Bodega.ReporteCursosIndexRoute = Bodega.AuthenticatedRoute.extend({
    setupController: function(controller, model) {
        colaboradorParams = {}
        colaboradorParams.unpaged = true;
        this.store.find('colaborador', colaboradorParams).then(function(response){
            controller.set('colaboradores', response);
        });
    }
});

Bodega.ReporteCursos = Bodega.AuthenticatedRoute.extend({});
