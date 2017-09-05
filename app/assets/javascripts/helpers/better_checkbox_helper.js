Bodega.BetterCheckboxComponent = Ember.Component.extend({
  attributeBindings: ['type', 'value', 'checked', 'disabled'],
  tagName: 'input',
  type: 'checkbox',
  checked: false,
  disabled: false,

  _updateElementValue: function() {
    this.set('checked', this.$().prop('checked'));
  }.on('didInsertElement'),

  change: function(event){
    this._updateElementValue();
    this.sendAction('action', this.get('value'), this.get('checked'));
  },
});
