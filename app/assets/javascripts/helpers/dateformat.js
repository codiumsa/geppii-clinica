Ember.Handlebars.registerBoundHelper('dateformat', function(value, options) {
  var date = moment(value);
  if (date.isValid()) {
    return date.tz('GMT').format('DD/MM/YYYY');
  } else {
    return "";
  }
});