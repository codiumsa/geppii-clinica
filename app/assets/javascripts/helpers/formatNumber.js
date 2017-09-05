Ember.Handlebars.helper('formatNumber', function(value, options) {
  if (value)
    return value.toLocaleString();
  else
    return 0;
});