Bodega.ColorInputComponent = Ember.TextField.extend({
    type: 'text',
    attributeBindings: ['min', 'max', 'step', 'disabled'],
    integer: true,

    didInsertElement: function() {
        var self = this;
        this.$().minicolors();
        this.$().attr('pattern', "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$");
        this.$().parent().addClass('form-control');
    }
});