Bodega.MonitoreoCajasIndexRoute = Bodega.AuthenticatedRoute.extend({
	model: function () {
		model = this.store.find('caja', {
			page: 1,
			monitoreo: true
		});
		return model;
	},

	setupController: function (controller, model) {
		controller.set('model', model);
		controller.set('currentPage', 1);
		var aliviar = false;
		model.get('content').forEach(function (caja) {
			if (caja.get("necesitaAlivio")) {
				aliviar = true;
			}
		});
		if (aliviar) {
			//alert("Una o más cajas necesitan alivio.\nVerifique las filas en rojo.");
			//setTimeout(function() { alert('Una o más cajas necesitan alivio.\nVerifique las filas en rojo.'); }, 1);
			Bodega.Notification.show("Alerta de alivio de cajas", "Una o más cajas necesitan alivio.\nVerifique las filas en rojo.", Bodega.Notification.WARNING_MSG);
		}
	}
});

Bodega.MonitoreoCajaRoute = Bodega.AuthenticatedRoute.extend({});
