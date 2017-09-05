(function(){
  var rojo =   '#cc1b1b';
  var verde =  '#377522';
  var blanco = '#ffffff';
  var azul =   '#005cb7';

  var hexToColorName = function(hexVal){
    if(hexVal === '#cc1b1b'){
      return 'rojo';
    }else if(hexVal === '#377522'){
      return 'verde';
    }else if(hexVal === '#ffffff'){
      return 'blanco';
    }else if(hexVal === '#005cb7'){
      return 'azul';
    }
    return null;
  };

  var colorNameToHex = function(colorName){
    if(colorName === 'rojo'){
      return '#cc1b1b';
    }else if(colorName === 'verde'){
      return '#377522';
    }else if(colorName === 'blanco'){
      return '#ffffff';
    }else if(colorName === 'azul'){
      return '#005cb7';
    }
    return null;
  };

  var tooth = function (toothId, cuadrante, diente){
    var stringSvg =
	'<svg' +
      '   xmlns:dc="http://purl.org/dc/elements/1.1/"' +
      '   xmlns:cc="http://creativecommons.org/ns#"' +
      '   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"' +
      '   xmlns:svg="http://www.w3.org/2000/svg"' +
      '   xmlns="http://www.w3.org/2000/svg"' +
      '   version="1.1"' +
      '   id="svg2"' +
      '   viewBox="0 0 38.976378 42.519685"' +
      '   height="12mm"' +
      '   width="11mm">' +
      '  <defs' +
      '     id="defs4" />' +
      '  <metadata' +
      '     id="metadata7">' +
      '    <rdf:RDF>' +
      '      <cc:Work' +
      '         rdf:about="">' +
      '        <dc:format>image/svg+xml</dc:format>' +
      '        <dc:type' +
      '           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />' +
      '        <dc:title></dc:title>' +
      '      </cc:Work>' +
      '    </rdf:RDF>' +
      '  </metadata>' +
      '  <g' +
      '     id=' + cuadrante + ' '+
      '     transform="matrix(0.04153189,0,0,0.03720845,3.2886216,-3.2779183)"' +
      '     style="stroke-width:4.04257107;stroke-miterlimit:4;stroke-dasharray:none">' +
      '    <g' +
      '       id="g4316"' +
      '       style="stroke-width:4.04257107;stroke-miterlimit:4;stroke-dasharray:none"' +
      '       transform="matrix(0.8499908,0,0,0.88686806,52.320046,-4.5183716)">' +
      '      <rect' +
      '         ry="7.318624"' +
      '         style="opacity:1;fill:none;fill-opacity:1;fill-rule:nonzero;stroke:#000000;stroke-width:4.09517717;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"' +
      '         id="center"' +
      '         width="730.76794"' +
      '         height="721.18683"' +
      '         x="29.179054"' +
      '         y="138.95088" />' +
      '      <rect' +
      '         ry="3.6622002"' +
      '         style="opacity:1;fill:none;fill-opacity:1;fill-rule:nonzero;stroke:#000000;stroke-width:19.99474716;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"' +
      '         id="rect4136-3"' +
      '         width="364.8855"' +
      '         height="276.92856"' +
      '         x="212.86665"' +
      '         y="347.56937" />' +
      '      <path' +
      '         style="opacity:1;fill:none;fill-opacity:1;fill-rule:nonzero;stroke:#000000;stroke-width:20.21285629;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"' +
      '         d="M 27.068462,152.0231 196.9768,343.24914 198.3318,633.14228 29.81392,842.62813 Z"' +
      '         id="left" />' +
      '      <path' +
      '         style="opacity:1;fill:none;fill-opacity:1;fill-rule:nonzero;stroke:#000000;stroke-width:20.21285629;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"' +
      '         d="M 740.88031,146.57035 579.55705,332.56259 206.46453,330.93294 38.247086,137.73859 c 231.761444,2.53192 451.399994,-0.17161 702.633224,8.83176 z"' +
      '         id="top" />' +
      '      <path' +
      '         style="opacity:1;fill:none;fill-opacity:1;fill-rule:nonzero;stroke:#000000;stroke-width:20.21285629;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"' +
      '         d="M 757.53088,842.01913 592.80247,632.40132 593.59827,344.23328 754.35164,160.6767 Z"' +
      '         id="right" />' +
      '      <path' +
      '         style="opacity:1;fill:none;fill-opacity:1;fill-rule:nonzero;stroke:#000000;stroke-width:20.21285629;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"' +
      '         d="M 747.83991,861.40888 577.15243,635.05454 214.14173,640.60479 39.085349,857.43291 Z"' +
      '         id="bottom" />' +
      '    </g>' +
      '  </g>' +
      '  <text' +
      '     transform="scale(0.98637393,1.0138143)"' +
      '     id="textId"' +
      '     y="41.090481"' +
      '     x="9.077651"' +
      '     style="font-style:normal;font-weight:normal;font-size:15px;line-height:125%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"' +
      '     xml:space="preserve"><tspan' +
      '       y="41.090481"' +
      '       x="9.077651"' +
      '       id="tspan4202"></tspan></text>' +
      '</svg>';
    
    var onClickCallback =  function() {
      var color = new SVG.Color(this.style('fill'));
      /*
  	si esta blanco cambiar a rojo
  	si esta rojo cambiar a verde
  	si esta verde cambiar a blanco
      */
      var fill = null;
      if(color.toHex() === blanco){
  	fill = rojo;
      }else if(color.toHex() === rojo){
  	fill = azul;
      }else if(color.toHex() === azul){
  	fill = verde;
      }else if(color.toHex() === verde){
  	fill = blanco;
      }
      this.style({fill: fill});
      //ponemos el nombre del color
      console.log("Cambiando el estado para ",this.id());
      diente.estado[this.id()] = hexToColorName(fill);
    };

    var odontograma = SVG(toothId).svg(stringSvg).size(40,45);
    //odontograma.scale(20, 20);  
    var txt = SVG.get('textId');  
    //remplazamos el id del texto para futuras referencias
    txt.attr({id: toothId});
    txt.tspan(toothId);
    var partsList =  [SVG.get('left'),
		      SVG.get('top'),
		      SVG.get('right'),
		      SVG.get('bottom'),
		      SVG.get('center')];

    if(diente.estado === null){
      diente.estado = {};
    }
    //preparamos los dientes
    //agregamos el manejador de eventos a cada parte
    //y remplazamos los ids
    partsList.forEach(function(part){
      part.attr({id: toothId + "_" + part.attr('id')});
      part.style({fill: blanco, cursor: 'pointer'});
      part.click(onClickCallback);
      if(diente.estado[part.attr('id')] === undefined){
	diente.estado[part.attr('id')] = 'blanco';
      }
    });
    //seteamos los colores que vienen de la base de datos
    //al SVG
    if(diente.estado !== null){
      Object.keys(diente.estado).forEach(function(estadoId){
	SVG.get(estadoId).style({fill: colorNameToHex(diente.estado[estadoId])});
      });
    }
    return self;
  };
  //recibir una estructura json con la info del odontograma:
  // - lista de dientes por cuadrante
  // - estado de cada diente (color)
  Bodega.views.OdontogramaSVGView = Ember.View.extend({
    self: this,
    tagName: 'tooth',
    init: function() {
      self.diente = this.get('diente');
      this.id = this.get('name');
    },
    didInsertElement: function(){
      tooth(this.get('name'), this.get('cuadrante'), this.get('diente'));
    }
  });
})();
