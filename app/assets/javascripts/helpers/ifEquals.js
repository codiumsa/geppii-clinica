Handlebars.registerHelper('ifEquals', function(value1, value2, options) {
	var obtained = this.get(value1);
    console.log('prueba');
    console.log(obtained);
    console.log(value2);
	if(obtained === value2){
		return options.fn(this);
	}
  return options.inverse(this);
});