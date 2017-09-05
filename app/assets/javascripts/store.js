// http://emberjs.com/guides/models/using-the-store/
// DS.ActiveModelAdapter.reopen(DS.EmbeddedRecordsMixin, {
//   namespace: "api/v1"
// });

Bodega.ApplicationAdapter = DS.ActiveModelAdapter.extend({
  namespace: 'api/v1'
});

//Bodega.ApplicationAdapter.configure('Bodega.CategoriaProducto', { primaryKey: 'categoria' });

Bodega.ApplicationSerializer = DS.ActiveModelSerializer.extend({

  extractMeta: function(store, type, payload) {
    if (payload && payload.meta) {
      store.metaForType(type, {
        totalPages: payload.meta.total_pages,
        total: payload.meta.total
      });
      delete payload.meta;
    } else {
      store.metaForType(type, {
        totalPages: 0,
        total: 0
      });
    }
  },

  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'meta') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  },

  serializeBelongsTo: function(record, json, relationship) {
    //console.log("Record: ", record, "JSon:", json, "RelationShip: ", relationship);
    var key = relationship.key,
    belongsToRecord = Ember.get(record, key);
    //console.log("BelongsTo: ", belongsToRecord);
    if (relationship.options.embedded === 'always') {
      if(belongsToRecord){
        json[key] = belongsToRecord.serialize();
      }else{
        json[key] = null;
      }
    } else {
      return this._super(record, json, relationship);
    }
  }
});


Bodega.VentaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    ventaDetalles: { embedded: 'always' },
    ventaMedios: { embedded: 'always' }
  },
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'venta') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }

});

Bodega.ContactoSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    contactoDetalles: { embedded: 'always' }
  },
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'contacto') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }

});

Bodega.CursoSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    cursoColaboradores: { embedded: 'always' },
  },
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'curso') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }

});

Bodega.ViajeSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    viajeColaboradores: { embedded: 'always' },
  },
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'viaje') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }

});

Bodega.VentaCuotaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'ventaCuota') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.TarjetaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'tarjeta') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.CompraCuotaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'compraCuota') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.CategoriaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'categoria') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.CategoriaProductoSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'categoriasProductos') {
      return inflector.singularize('categoriaProductos');
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.CategoriaClientePromocionSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'categoriaClientesPromociones') {
      return inflector.singularize('categoriaClientePromocion');
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.PromocionSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'promociones') {
      return inflector.singularize('promocion');
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.OperacionCajaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'operacionesCaja') {
      return inflector.singularize('operaciones_caja');
    } else {
      return inflector.singularize(camelized);
    }
  }
});


Bodega.UsuarioSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    roles: { embedded: 'always' },
    sucursales: { embedded: 'always' }
  },
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'usuario') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.ProduccionSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    produccionDetalles: { embedded: 'always' }
  },

  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'produccion') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.VendedorSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    sucursales: { embedded: 'always' }
  },
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'vendedor') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.RegistroProduccionSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'registrosProduccion') {
      return inflector.singularize('registro_produccion');
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.MedioPagoSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'medioPagos') {
      return inflector.singularize('medio_pagos');
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.CompraSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    compraDetalles: { embedded: 'always' }

  }
});

Bodega.EspecialidadSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'especialidades') {
      return inflector.singularize('especialidad');
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.CompraDetalleSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    producto: { embedded: 'always' },
    lote: { embedded: 'always' },
    contenedor: { embedded: 'always' }
  }
});

Bodega.TransferenciaDepositoSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    detalle: { embedded: 'always' }

  }
});

Bodega.TransferenciaDepositoDetalleSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    producto: { embedded: 'always' }

  }
});

Bodega.AjusteInventarioSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    detalle: { embedded: 'always' }

  }
});

Bodega.AjusteInventarioDetalleSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    producto: { embedded: 'always' }

  }
});

Bodega.PromocionSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    detalle: { embedded: 'always' }

  }
});

Bodega.PromocionProductoSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    producto: { embedded: 'always' }

  }
});

Bodega.InventarioSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    inventarioLote: { embedded: 'always' }
  }
});

Bodega.InventarioLoteSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    producto: { embedded: 'always' }
  }
});

Bodega.ClienteSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    persona: { embedded: 'always' },
    referencias: { embedded: 'always' },
    documentos: { embedded: 'always' },
    ingresoFamiliares: { embedded: 'always' },
    calificacion: { embedded: 'always' },
    promociones: { embedded: 'always' }
  },

  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'cliente') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.ProductoSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    categorias: { embedded: 'always' },
    productoDetalles: { embedded: 'always' }
  },
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'producto') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.ProductoDetalleSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    producto: { embedded: 'always' }
  },

  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'productoDetalle') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.PagoSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    pagoDetalles: { embedded: 'always' }
  },
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'pago') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.TipoOperacionDetalleSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'tipoOperacionDetalle') {
      return inflector.singularize('tipo_operacion_detalle');
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.TipoOperacionSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'tipoOperacion') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.TipoMovimientoSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'tipoMovimiento') {
      return inflector.singularize('tipo_movimiento');
    } else {
      return inflector.singularize(camelized);
    }
  }
});
Bodega.TipoProductoSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'tipoProducto') {
      return inflector.singularize('tipo_producto');
    } else {
      return inflector.singularize(camelized);
    }
  }
});
Bodega.MovimientoSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'movimiento') {
      return inflector.singularize('movimiento');
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.PersonaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    conyugue: { embedded: 'always' }
  },

  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'persona') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.ConyugueSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'conyugue') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});


Bodega.PacienteSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    persona: { embedded: 'always' },
    fichasFonoaudiologia: { embedded: 'always' },
    candidaturas: { embedded: 'always' }
  },

  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'paciente') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});


Bodega.FichaFonoaudiologiaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    paciente: { embedded: 'always' }
  },

  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'fichaFonoaudiologia'){
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});
Bodega.FichaNutricionSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    paciente: { embedded: 'always' }
  },

  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'fichaNutricion'){
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.FichaCirugiaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    paciente: { embedded: 'always' },
    campanha: { embedded: 'always' },
  },

  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'fichaCirugia'){
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.FichaPsicologiaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    paciente: { embedded: 'always' }
  },

  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'fichaPsicologia'){
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.FichaOdontologiaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    paciente: { embedded: 'always' },
    consultaDetalles: { embedded: 'always' }
  },

  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'fichaOdontologia'){
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.TipoCampanhaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'tipoCampanha') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.CampanhaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'campanha') {
      return inflector.singularize('campanha');
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.CampanhaColaboradorSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    console.log('CampanhaColaboradorCamelize: ', camelized);
    if (camelized === 'campanhaColaborador'){
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.TipoColaboradorSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'tipoColaborador') {
      return inflector.singularize('tipo_colaborador');
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.ColaboradorSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    campanhasColaboradores: { embedded: 'always' },
  },
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'colaborador') {
      return inflector.singularize('colaborador');
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.ConsultaSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    consultaDetalles: { embedded: 'always' },
    consultaListas: { embedded: 'always' }
  },
  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'consulta') {
      return inflector.singularize('consulta');
    } else {
      return inflector.singularize(camelized);
    }
  }
});

Bodega.SponsorSerializer = Bodega.ApplicationSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    persona: { embedded: 'always' }
  },

  typeForRoot: function(root) {
    var camelized = Ember.String.camelize(root);
    if (camelized === 'sponsor') {
      return camelized;
    } else {
      return inflector.singularize(camelized);
    }
  }
});

DS.Store.reopen({
  // Override the default adapter with the `DS.ActiveModelAdapter` which
  // is built to work nicely with the ActiveModel::Serializers gem.
  // adapter: '-active-model'
  adapter: Bodega.ApplicationAdapter
    //adapter: DS.FixtureAdapter
});
