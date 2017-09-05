Bodega.IsodateTransform = DS.Transform.extend({
  deserialize: function (serialized) {
    if (serialized) {
      var value = moment(serialized);
      var offset = moment.tz.zone("America/Asuncion").offset(value.unix() * 1000) / 60;
      //Consideramos primero el caso de fechas guardadas erroneamente como timestamp
      if((value.hours() + offset) === 24 && value.minutes() === 0 && value.seconds() === 0){
        return moment(serialized).add(offset, 'hours').toDate();
      }else{
        return moment(serialized).toDate();
      }
    }
    return serialized;
  },

  serialize: function (deserialized) {
    if (deserialized) {
      return moment(deserialized).format();
    }
    return deserialized;
  }
});