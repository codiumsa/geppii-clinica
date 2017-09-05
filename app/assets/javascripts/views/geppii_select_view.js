Bodega.views = Bodega.views || {};

//sobre escribe el select de ember para agregar
// onChange de manera mas simple
Bodega.views.GeppiiSelect = Ember.Select.extend({  
  change: function () {
    var self = this;
//    this._super(); no anda para chrome
    var callback = this.get('onChange');
    if (callback) {
      Em.run.later(function () {
        self.get('controller').send(callback);
      });
    }
  }
});
