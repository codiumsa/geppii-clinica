//Misma historia, como hacemos i18n???
Ember.Handlebars.helper('yesnonull', function(value, options) {
  if (value == null){
      return '-';
    }else if (value) {
      return 'Sí';
    }{
      return 'No';
    }
});
