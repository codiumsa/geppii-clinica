Bodega.JsonTransform = DS.Transform.extend({
  deserialize: function (serialized) {
    if (serialized) {
      return JSON.parse(serialized);
    }
    return serialized;
  },

  serialize: function (deserialized) {
    //nothing to do here...
    return deserialized;
  }
});
