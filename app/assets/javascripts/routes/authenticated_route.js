Bodega.AuthenticatedRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, Bodega.AuthenticatedRouteMixin,
{
  beforeModel: function(transition) {
    var appController = this.controllerFor('application');
    //console.log(appController);
    if(!this.session.isAuthenticated) {
      appController.set('previousTransition', transition);
      this.transitionTo('sessions.new');
    }
  },
  
  actions: {
      willTransition: function(transition) {
        $('body').removeClass('modal-open');
        var appController = this.controllerFor('application');
        appController.set('containerHeight', Bodega.newHeightWrapper(true));
        var model = this.get('currentModel');
        if (model && model.get('isDirty')) {
          if (true) {
            //Stay on same page and continue editing
            //transition.abort();
         // } else {
            //Delete created record
            var model = this.get('currentModel');
            if (!model.get('id')) {
              model.deleteRecord();
            } else {
              model.rollback();
            }
          }
        } 
      },
      error: function(reason) {
          if (reason.status === 401) {
            this.get('session').invalidate();
            location.reload();
          }
          return true;
        }
      // error: function(xhr, transition, route) {
      //   if (xhr) {
      //     var status = xhr.status;
      //     if (status == 401) {
      //       // Reset the session to avoid an infinite loop.
      //       console.log("asfasdfadsf");
      //       this.get('session').invalidate();
      //       location.reload();
      //       // if (Ember.canInvoke(transition, 'send')) {
      //       //   transition.send('sessions.new');
      //       // } else {
      //       //   this.send('sessions.new');
      //       // }
      //     }
      //     else {
      //       // Handle other errors
      //     }
      //   }
      // }
    }
  
});