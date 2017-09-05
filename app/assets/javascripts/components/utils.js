/*global Bodega, PNotify, $, console, moment */
/**
 * Helpers varios
 *
 * @author Jorge Ramírez <jorge@codium.com.py>
 **/
(function() {
  'use strict';
  
  var Utils = {};

  Utils.disableElement = function(selector) {
   
    if(selector === undefined) {
      console.error('Selector no especificado');
      return;
    }
    $(selector).attr('disabled','disabled');
  };


  Utils.enableElement = function(selector) {
    
    if(selector === undefined) {
      console.error('Selector no especificado');
      return;
    }
    $(selector).removeAttr('disabled');
  };

  /**
   * Retorna la fecha actual como string en el formato DD/MM/YYYY
   **/
  Utils.getCurrentDate = function(dateFormat) {
    
    if(dateFormat === undefined){
      dateFormat = 'DD/MM/YYYY';
    }
    return moment(new Date()).format(dateFormat);
  };
  

  /**
  * Imprime un archivo en formato PDF.
  * @url     la URL base del servicio que retorna el PDF.
  * @params  los queryparams en formato {p1: v1, p2: v2, ...}
  * @element un selector jquery correspondiente a un elemento de la pagina actual
  **/

  Utils.printPdf = function(url, params, element){
    console.log('printpdf');
    var queryString = $.param(params);
    if(document.getElementById('pdfDocument')){
      document.getElementById('pdfDocument').remove();
    }

    $('body').append('<iframe src="' + url + '?' + queryString + '" id="pdfDocument" style="display: none;"></iframe>');

    var doc = document.getElementById('pdfDocument');

    //Wait until PDF is ready to print    
    if (typeof doc.contentWindow.print === 'undefined') {    
        setTimeout(function(){Utils.printPdf(url, params, element);}, 1000);
    } else {
        doc.focus()
        doc.contentWindow.print();
    }

  }

  Bodega.Utils = Utils;
})();
