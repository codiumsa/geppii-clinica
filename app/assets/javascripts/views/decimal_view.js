Bodega.DecimalField = Em.TextField.extend({
  classNames: ["decimal-field"],
  currentValue: undefined,
  init: function() {
    this._super();
    this.numberPlaceholder = this.get("number");
    this.currentValue = '';
  },

  didInsertElement : function(){
    var self = this;
    var n = this.get('number') || 0.00;
    this._super();
   
    this.$().autoNumeric('init', {
      aSep: '.',
      aDec: ','
    });

    this.$().autoNumeric('set', n);
    this.$().blur(function(e){
      var value = self.get('value');
      if(value && value[0] ==='0' && value[1] !== ','){
        self.set('value', value.replace(/^0+/, ''));
        self.$().get(0).setSelectionRange(0, 2);
      }
    });
  },


  updateNumber: function() {
    var value = this.get('value');
    var number = parseFloat(this.$().autoNumeric('get'));
    this.set("number", number);
  }.observes("value"),


});

Ember.Handlebars.helper("decimal-field", Bodega.DecimalField);