Bodega.ClientesIndexView = Ember.View.extend({
    templateName: 'clientes/index',

    eventManager: Ember.Object.create({
      doubleClick: function(event, view) {
        var target = $(event.originalEvent.target);
        
        if(target.is('td')){
          var row = target.parent()[0];
          var controller = Bodega.__container__.lookup('controller:clientes.index');
          controller.send('goEditCliente', row.dataset.clienteId);
        }
      }
    })
});
