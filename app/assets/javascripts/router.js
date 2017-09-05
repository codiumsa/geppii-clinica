Ember.Route.reopen({
  allowFileDrop: false,

  activate: function() {
    this._super();
    if (this.get('allowFileDrop')) {
      this.controllerFor('application').incrementProperty('allowFileDrop');
    }
  },

  deactivate: function() {
    this._super();
    if (this.get('allowFileDrop')) {
      this.controllerFor('application').decrementProperty('allowFileDrop');
    }
  }
});

Bodega.Router.reopen({
  location: 'history'
});

Bodega.Router.map(function() {

  this.resource("ventas", function() {
    this.route('new');
    this.resource("venta", { path: "/:venta_id" }, function() {
      this.route('edit');
      this.route('duplicar');
      this.route('delete');
      this.resource("ventaCuotas", { path: "/cuotas" }, function() {
        this.resource("ventaCuota", { path: "/:venta_cuota_id" }, function() {
          this.route('edit');
        });
      });

      this.resource("pagos", { path: "/pagos" }, function() {
        this.route('new');
        this.resource("pago", { path: "/:pago_id" }, function() {
          this.route('edit');
          this.route('delete');
        });
      });

    });
  });

  this.resource("reporte_listado_voluntarios", function() {

  });

  this.resource("reporte_viajes", function() {

  });
  
  this.resource("reporte_patrocinadores", function() {

  });
  
  this.resource("reporte_cursos", function() {

  });
  
  this.resource("reporte_pacientes", function() {
    
  });

  this.resource("reporte_candidatura_tratamientos", function() {

  });
  this.resource("reporte_informacion_voluntarios", function() {

  });

  this.resource("reporte_asistencia_pacientes_consultas", function() {

  });


  this.resource("reporte_participacion_voluntarios", function() {

  });

  this.resource("reporte_cantidad_tratamientos", function() {

  });

  this.resource("reporte_valoracion_inventario", function() {

  });

  this.resource("reporte_existencia_inventario", function() {

  });

  this.resource("reporte_legajo_paciente", function() {

  });

  this.resource("reporte_ajustes_inventario", function() {

  });

  this.resource("reporte_compras", function() {

  });

  this.resource("reporte_cantidad_consultas", function() {

  });

  this.resource("reporte_cantidad_pacientes_atendidos", function() {

  });



  this.resource("reporte_cuentas_pagar", function() {

  });

  this.resource("reporte_cuentas_cobrar", function() {

  });

  this.resource("reporte_salida_campanha", function() {

  });

  this.resource("reporte_ventas", function() {

  });

  this.resource("reporte_sesion_cajas", function() {

  });

  this.resource("fichas", function() {

  });

  this.resource("reporte_ganancias", function() {

  });

  this.resource("reporte_producto_deposito", function() {

  });

  this.resource("reporte_producto_lote", function() {

  });

  this.resource("reporte_producto_recargo", function() {

  });

  this.resource("reporte_movimiento_caja", function() {

  });

  this.resource("reporte_operacion", function() {

  });

  this.resource("reporte_pacientes_nuevos", function() {

  });

  this.resource("reporte_caja_usuario", function() {

  });

  this.resource("reporte_descuento", function() {

  });

  this.resource("reporte_evento", function() {

  });


  this.resource("compras", function() {
    this.route('new');
    this.resource("compra", { path: "/:compra_id" }, function() {
      this.route('edit');
      this.route('delete');
      this.resource("compraCuotas", { path: "/cuotas" }, function() {
        this.resource("compraCuota", { path: "/:compra_cuota_id" }, function() {
          this.route('edit');
        });
      });

      this.resource("pagos", { path: "/pagos" }, function() {
        this.route('new');
        this.resource("pago", { path: "/:pago_id" }, function() {
          this.route('edit');
          this.route('delete');
        });
      });

    });
  });

  this.resource("cajas", function() {
    this.route('new');
    this.resource("caja", { path: "/:caja_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("cursos", function() {
    this.route('new');
    this.resource("curso", { path: "/:curso_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("viajes", function() {
    this.route('new');
    this.resource("viaje", { path: "/:viaje_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("especialidades", function() {
    this.route('new');
    this.resource("especialidad", { path: "/:especialidad_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("operaciones", function() {
    this.route('new');
    this.resource("operacion", { path: "/:operacion_id" }, function() {
      this.route('edit');
      this.route('delete');
    });

  });

  this.resource("usuarios", function() {
    this.route('new');
    this.resource("usuario", { path: "/:usuario_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("promociones", function() {
    this.route('new');
    this.resource("promocion", { path: "/:promocion_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("promocion_productos", function() {
    this.route('new');
    this.resource("promocion_producto", { path: "/:promocion_producto_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("proveedores", function() {
    this.route('new');
    this.resource("proveedor", { path: "/:proveedor_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("sucursales", function() {
    this.route('new');
    this.resource("sucursal", { path: "/:sucursal_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("consultorios", function() {
    this.route('new');
    this.resource("consultorio", { path: "/:consultorio_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("consultas", function() {
    this.route('new');
    this.resource("consulta", { path: "/:consulta_id" }, function() {
      this.route('edit');
      this.route('delete');
      this.resource("consulta_detalles", function() {
        this.route('new');
      });
    });
  });
  this.resource("consulta_detalles", function() {
    this.route('new');
    this.resource("consulta_detalle", { path: "/:consulta_detalle_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource('sessions', function() {
    this.route('new');
  });

  this.resource("categorias", function() {
    this.route('new');
    this.resource("categoria", { path: "/:categoria_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("productos", function() {
    this.route('new');
    this.resource("producto", { path: "/:producto_id" }, function() {
      this.route('edit');
      this.route('delete');
    });

  });

  this.resource("tipoProductos", function() {
    this.route('new');
    this.resource("tipoProducto", { path: "/:tipo_producto_id" }, function() {
      this.route('edit');
      this.route('delete');
    });

  });


  this.resource("inventarios", function() {
    this.route('new');
    this.resource("inventario", { path: "/:inventario_id" }, function() {
      this.route('edit');
      this.route('delete');
      this.resource("inventario_lotes", function() {
        this.route('new');
      });
    });
  });

  this.resource("controlInventarios", function() {
    this.route('new');
    this.resource("controlInventario", { path: "/:control_inventario_id" }, function() {
      this.route('edit');
      this.route('delete');
      this.resource("control_inventario_productos", function() {
        this.route('new');
      });
    });
  });

  this.resource("ajusteInventarios", function() {
    this.route('new');
    this.resource("ajusteInventario", { path: "/:ajuste_inventario_id" }, function() {
      this.route('edit');
      this.resource("ajuste_inventario_detalles", function() {
        this.route('new');
      });
    });
  });

  this.route("noEncontrado", { path: "*path" });

  this.resource("sesionCajas", function() {
    this.route('new');
    this.resource("sesionCaja", { path: "/:sesion_caja_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("reporte_inventarios", function() {

  });

  this.resource("tipoCreditos", function() {
    this.route('new');
    this.resource("tipoCredito", { path: "/:tipo_credito_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("categoriaOperaciones", function() {
    this.route('new');
    this.resource("categoriaOperacion", { path: "/:categoria_operacion_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("categoriaClientes", function() {
    this.route('new');
    this.resource("categoriaCliente", { path: "/:categoria_cliente_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("depositos", function() {
    this.route('new');
    this.resource("deposito", { path: "/:deposito_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("motivosInventarios", function() {
    this.route('new');
    this.resource("motivosInventario", { path: "/:motivos_inventario_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("producciones", function() {
    this.route('new');
    this.resource("produccion", { path: "/:produccion_id" }, function() {
      this.route('edit');
      this.route('delete');
      // this.resource("produccion_detalles", function() {
      //   this.route('new');
      // });
    });
  });

  this.resource("transferenciasDeposito", function() {
    this.route('new');
    this.resource("transferenciaDeposito", { path: "/:transferencia_id" }, function() {
      this.route('edit');
      this.route('delete');
      this.resource("transferenciaDepositoDetalles", function() {
        this.route('new');
      });
    });
  });
  this.resource("registrosProduccion", function() {
    this.route('new');
    this.resource("registroProduccion", { path: "/:registro_produccion_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("loteDepositos", function() {

  });

  this.resource("vendedores", function() {
    this.route('new');
    this.resource("vendedor", { path: "/:vendedor_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("cajasImpresion", function() {
    this.route("new");
    this.resource("cajaImpresion", { path: "/:caja_impresion_id" }, function() {
      this.route("edit");
      this.route("delete");
    });
  });

  this.resource("monedas", function() {
    this.route('new');
    this.resource("moneda", { path: "/:moneda_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("cotizaciones", function() {
    this.route('new');
  });

  this.resource("medioPagos", function() {
    this.route('new');
    this.resource("medioPago", { path: "/:medio_pago_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("tarjetas", function() {
    this.route('new');
    this.resource("tarjeta", { path: "/:tarjeta_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("recargos", function() {
    this.route('new');
    this.resource("recargo", { path: "/:recargo_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("reporte_extracto_cliente", function() {});

  this.resource("reporte_movimiento_venta", function() {});
  this.resource("reporte_precios_venta", function() {});

  this.resource("reporte_ventas_medio_pago", function() {});

  this.resource("reporte_final_caja", function() {});
  this.resource("reporte_caja_medio_pago", function() {});

  this.resource("movimientos", function() {
    this.route('new');
    this.resource("movimiento", { path: "/:movimiento_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("monitoreo_cajas", function() {});

  this.resource("pacientes", function() {
    this.route('new');
    this.resource("paciente", { path: "/:paciente_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("tratamientos", function() {
    this.route('new');
    this.resource("tratamiento", { path: "/:tratamiento_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("calificaciones", function() {
    this.route('new');
    this.resource("calificacion", { path: "/:calificacion_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("colaboradores", function() {
    this.route('new');
    this.resource("colaborador", { path: "/:colaborador_id" }, function() {
      this.route('edit');
      this.route('delete');
      this.resource("campanhas_colaboradores", function() {
        this.route('new');
      });
    });
  });

  this.resource("campanhas_colaboradores", function() {
    this.route('new');
    this.resource("campanha_colaborador", { path: "/:campanha_colaborador_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("tipo_colaboradores", function() {
    this.route('new');
    this.resource("tipo_colaborador", { path: "/:tipo_colaborador_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("fichasFonoaudiologia", function() {
    this.route('new');
    this.resource("fichaFonoaudiologia", { path: "/:ficha_fonoaudiologia_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("fichasCirugia", function() {
    this.route('new');
    this.resource("fichaCirugia", { path: "/:ficha_cirugia_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("fichasOdontologia", function() {
    this.route('new');
    this.resource("fichaOdontologia", { path: "/:ficha_odontologia_id" }, function() {
      this.route('edit');
      this.route('delete');
      this.resource("consulta_detalles", function() {
        this.route('new');
      });
    });
  });
  this.resource("fichasNutricion", function() {
    this.route('new');
    this.resource("fichaNutricion", { path: "/:ficha_nutricion_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("fichasPsicologia", function() {
    this.route('new');
    this.resource("fichaPsicologia", { path: "/:ficha_psicologia_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("clientes", function() {
    this.route('new');
    this.resource("cliente", { path: "/:cliente_id" }, function() {
      this.route('edit');
      this.route('delete');

      this.resource("referencias", { path: "/referencias" }, function() {});

      this.resource("ingresoFamiliares", { path: "/ingresoFamiliares" }, function() {});

      this.resource("documentos", { path: "/documentos" }, function() {});
    });
  });


  this.resource("sponsors", function() {
    this.route('new');
    this.resource("sponsor", { path: "/:sponsor_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("tipoContactos", function() {
    this.route('new');
    this.resource("tipoContacto", { path: "/:tipo_contacto_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

  this.resource("contactos", function() {
    this.route('new');
    this.resource("contacto", { path: "/:contacto_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });

	this.resource("campanhas", function() {
    this.route('new');
    this.resource("campanha", { path: "/:campanha_id" }, function() {
      this.route('edit');
      this.route('delete');
    });
  });
});
