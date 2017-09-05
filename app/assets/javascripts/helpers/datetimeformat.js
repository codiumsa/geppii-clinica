Ember.Handlebars.registerBoundHelper('datetimeformat', function(value, options) {
  var date = moment(value);
  if (date.isValid()) {
    return date.format('DD/MM/YYYY hh:mm a');
  } else {
    return "";
  }
});