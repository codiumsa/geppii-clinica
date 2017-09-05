// for more details see: http://emberjs.com/guides/models/defining-models/

Bodega.Caja = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string'),
  sucursal: DS.belongsTo('sucursal',{ async: true }),
  tipoCaja: DS.attr('string'),
  saldo: DS.attr('number'),
  usuario: DS.belongsTo('usuario',{async: true}),
  moneda:DS.belongsTo('moneda',{async:true}),
  abierta: DS.attr('boolean', {defaultValue: false}),
	necesitaAlivio: DS.attr('boolean', {defaultValue: false}),
	limiteAlivio: DS.attr('number'),
  tipo: function () {
    var tiposCaja = {"U" : "Usuario",
                "O" : "Otra",
                "P" : "Principal"};
    return tiposCaja[this.get('tipoCaja')];
  }.property('tipoCaja'),
	excedente: function () {
    if(this.get("necesitaAlivio")){
			return this.get("saldo") - this.get("limiteAlivio");
		}else{
			return 0;
		}
  }.property('excedente')
});
