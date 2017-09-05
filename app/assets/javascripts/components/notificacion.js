/*global Bodega, PNotify */
(function() {
  'use strict';
  
  Bodega.Notification = {};
  Bodega.Notification.ERROR_MSG = "error";
  Bodega.Notification.SUCCESS_MSG = "success";
  Bodega.Notification.WARNING_MSG = "warning";

  Bodega.Messages = {};
  Bodega.Messages.mensajeRequiereApertura = "Debe realizar la 'Apertura de caja' antes de realizar la operación";

  Bodega.Notification.show = function(title, msg, msgType) {

    if(msgType === undefined) {
      msgType = Bodega.Notification.SUCCESS_MSG;
    }
    
    new PNotify({
      title: title,
      text: msg,
      type: msgType,
      animate_speed: 'fast'
    });
  };
})();
