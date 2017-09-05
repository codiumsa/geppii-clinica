Bodega.views = Bodega.views || {};

Bodega.views.DatePickerView = Ember.View.extend({
  templateName: 'date_picker',

  placeholder: 'd/m/aaaa',

  autofocus : false,

  setFecha: function() {
    var date =  Ember.get(this, 'value');
    
    if (date) {
      this.set('fecha', moment(date).format('DD/MM/YYYY'));
    }

  },

  didInsertElement: function() {
    if (!Ember.get(this, 'readonly')) {
      $('.input-group.date').datepicker({
        language: "es", autoclose: true, todayHighlight: true, format: "dd/mm/yyyy"
      });
    }
    this.setFecha();

    if (Ember.get(this, 'autofocus')) {
      this.$().focus();
    }
  },

  value: null,

  readonly : false,

  lastValid: null,

  nullable: null,

  widgetClass: "filter form-control",

  valueChangeObserver: function() {
    var value = this.get('value');
    
    if(!value) {
      this.$('input').val('');
      return;
    }
    this.setFecha();
  }.observes('value'),

  change: function() {
    var fecha = Ember.get(this, 'fecha');
    var date = moment(fecha, 'DD/MM/YYYY');

    if (Ember.get(this, 'nullable') && fecha === "") {
      this.set('value', null);
    } else if (!date.isValid()) {
      
      if ( Ember.get(this, 'nullable')) {
        this.set('value', null);
      }
    } else {
      this.set('value', date.toDate());
    }
    
  },

  
  focusIn:function (event) {
    var date = moment(Ember.get(this, 'fecha'), 'DD/MM/YYYY');

    if ( !Ember.get(this, 'nullable')) {
      
      if (!date.isValid()) {
        this.set('lastValid', null);
      } else {
        this.set('lastValid', date);
      }
    }

  },

  focusOut:function (event) {
    if (!Ember.get(this, 'nullable')) {
      var lastValid = Ember.get(this, 'lastValid');

      if (lastValid) {
        this.set('value', lastValid.toDate());
        this.set('fecha', lastValid.format('DD/MM/YYYY'));
      }
    }
  }
});
