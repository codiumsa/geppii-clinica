# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170523182031) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ajuste_inventario_detalles", force: true do |t|
    t.integer  "cantidad"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "producto_id"
    t.integer  "ajuste_inventario_id"
    t.integer  "lote_id"
    t.integer  "motivos_inventario_id"
  end

  add_index "ajuste_inventario_detalles", ["ajuste_inventario_id"], name: "index_ajuste_inventario_detalles_on_ajuste_inventario_id", using: :btree
  add_index "ajuste_inventario_detalles", ["lote_id"], name: "index_ajuste_inventario_detalles_on_lote_id", using: :btree
  add_index "ajuste_inventario_detalles", ["motivos_inventario_id"], name: "index_ajuste_inventario_detalles_on_motivos_inventario_id", using: :btree
  add_index "ajuste_inventario_detalles", ["producto_id"], name: "index_ajuste_inventario_detalles_on_producto_id", using: :btree

  create_table "ajuste_inventarios", force: true do |t|
    t.date     "fecha"
    t.string   "observacion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_id"
    t.integer  "deposito_id"
  end

  add_index "ajuste_inventarios", ["deposito_id"], name: "index_ajuste_inventarios_on_deposito_id", using: :btree
  add_index "ajuste_inventarios", ["usuario_id"], name: "index_ajuste_inventarios_on_usuario_id", using: :btree

  create_table "api_keys", force: true do |t|
    t.integer  "usuario_id"
    t.string   "access_token"
    t.string   "scope"
    t.datetime "expired_at"
    t.datetime "created_at"
    t.integer  "sucursal_id"
    t.integer  "caja_impresion_id"
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", unique: true, using: :btree
  add_index "api_keys", ["caja_impresion_id"], name: "index_api_keys_on_caja_impresion_id", using: :btree
  add_index "api_keys", ["sucursal_id"], name: "index_api_keys_on_sucursal_id", using: :btree
  add_index "api_keys", ["usuario_id"], name: "index_api_keys_on_usuario_id", using: :btree

  create_table "cajas", force: true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tipo_caja"
    t.integer  "sucursal_id"
    t.integer  "moneda_id"
    t.float    "saldo"
    t.integer  "usuario_id"
    t.boolean  "abierta",     default: false
  end

  add_index "cajas", ["moneda_id"], name: "index_cajas_on_moneda_id", using: :btree
  add_index "cajas", ["sucursal_id"], name: "index_cajas_on_sucursal_id", using: :btree
  add_index "cajas", ["usuario_id"], name: "index_cajas_on_usuario_id", using: :btree

  create_table "cajas_impresion", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calificaciones", force: true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.integer  "dias_atraso"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "calificaciones", ["codigo"], name: "index_calificaciones_on_codigo", unique: true, using: :btree
  add_index "calificaciones", ["descripcion"], name: "index_calificaciones_on_descripcion", unique: true, using: :btree
  add_index "calificaciones", ["dias_atraso"], name: "index_calificaciones_on_dias_atraso", unique: true, using: :btree

  create_table "campanha_sponsors", force: true do |t|
    t.integer  "campanha_id"
    t.integer  "sponsor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campanha_sponsors", ["campanha_id"], name: "index_campanha_sponsors_on_campanha_id", using: :btree
  add_index "campanha_sponsors", ["sponsor_id"], name: "index_campanha_sponsors_on_sponsor_id", using: :btree

  create_table "campanhas", force: true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.date     "fecha_incio"
    t.date     "fecha_fin"
    t.string   "estado"
    t.integer  "persona_id"
    t.integer  "tipo_campanha_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activo"
  end

  add_index "campanhas", ["persona_id"], name: "index_campanhas_on_persona_id", using: :btree
  add_index "campanhas", ["tipo_campanha_id"], name: "index_campanhas_on_tipo_campanha_id", using: :btree

  create_table "campanhas_colaboradores", force: true do |t|
    t.integer  "colaborador_id"
    t.integer  "campanha_id"
    t.string   "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campanhas_colaboradores", ["campanha_id"], name: "index_campanhas_colaboradores_on_campanha_id", using: :btree
  add_index "campanhas_colaboradores", ["colaborador_id"], name: "index_campanhas_colaboradores_on_colaborador_id", using: :btree

  create_table "candidaturas", force: true do |t|
    t.integer  "paciente_id"
    t.integer  "especialidad_id"
    t.integer  "colaborador_id"
    t.date     "fecha"
    t.boolean  "clinica"
    t.integer  "campanha_id"
    t.date     "fecha_posible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "candidaturas", ["campanha_id"], name: "index_candidaturas_on_campanha_id", using: :btree
  add_index "candidaturas", ["colaborador_id"], name: "index_candidaturas_on_colaborador_id", using: :btree
  add_index "candidaturas", ["especialidad_id"], name: "index_candidaturas_on_especialidad_id", using: :btree
  add_index "candidaturas", ["paciente_id"], name: "index_candidaturas_on_paciente_id", using: :btree

  create_table "categoria_clientes", force: true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categoria_clientes_promociones", force: true do |t|
    t.integer  "categoria_cliente_id"
    t.integer  "promocion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categoria_clientes_promociones", ["categoria_cliente_id"], name: "index_categoria_clientes_promociones_on_categoria_cliente_id", using: :btree
  add_index "categoria_clientes_promociones", ["promocion_id"], name: "index_categoria_clientes_promociones_on_promocion_id", using: :btree

  create_table "categoria_operaciones", force: true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.boolean  "activo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo_operacion_id"
  end

  add_index "categoria_operaciones", ["tipo_operacion_id"], name: "index_categoria_operaciones_on_tipo_operacion_id", using: :btree

  create_table "categorias", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "comision",   default: 0.0
  end

  create_table "categorias_productos", force: true do |t|
    t.integer  "producto_id"
    t.integer  "categoria_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categorias_productos", ["categoria_id"], name: "index_categorias_productos_on_categoria_id", using: :btree
  add_index "categorias_productos", ["producto_id"], name: "index_categorias_productos_on_producto_id", using: :btree

  create_table "ciudades", force: true do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ciudades", ["codigo"], name: "index_ciudades_on_codigo", unique: true, using: :btree
  add_index "ciudades", ["nombre"], name: "index_ciudades_on_nombre", unique: true, using: :btree

  create_table "clientes", force: true do |t|
    t.integer  "persona_id"
    t.integer  "numero_cliente",           default: "nextval('numero_cliente_seq'::regclass)"
    t.boolean  "activo"
    t.integer  "calificacion_id"
    t.float    "antiguedad"
    t.float    "salario_mensual"
    t.string   "matricula_nro"
    t.string   "ramo"
    t.float    "otros_ingresos"
    t.string   "empleador"
    t.string   "pariente1"
    t.string   "pariente2"
    t.float    "ingreso_pariente2"
    t.string   "domicilio"
    t.string   "cargo"
    t.string   "telefono"
    t.string   "jubilado"
    t.string   "institucion"
    t.string   "comerciante"
    t.boolean  "empleado"
    t.string   "profesion"
    t.string   "actividad_empleador"
    t.string   "direccion_empleador"
    t.integer  "ciudad_id"
    t.string   "barrio_empleador"
    t.date     "fecha_pago_sueldo"
    t.string   "concepto_otros_ingresos"
    t.boolean  "ips"
    t.date     "fecha_ingreso_informconf"
    t.date     "fecha_egreso_informconf"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clientes", ["calificacion_id"], name: "index_clientes_on_calificacion_id", using: :btree
  add_index "clientes", ["ciudad_id"], name: "index_clientes_on_ciudad_id", using: :btree
  add_index "clientes", ["persona_id"], name: "index_clientes_on_persona_id", using: :btree

  create_table "colaboradores", force: true do |t|
    t.integer  "persona_id"
    t.integer  "tipo_colaborador_id"
    t.integer  "especialidad_id"
    t.boolean  "voluntario"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "licencia"
    t.boolean  "activo"
    t.string   "nombre_club"
    t.string   "nombre_contacto_club"
    t.string   "celular_contacto_club"
    t.string   "email_contacto_club"
    t.boolean  "acreditado",                  default: false
    t.boolean  "comisionamiento",             default: false
    t.string   "tipo"
    t.string   "titulo"
    t.string   "institucion"
    t.string   "talle_remera"
    t.string   "lugar_trabajo_1"
    t.string   "lugar_trabajo_3"
    t.string   "lugar_trabajo_2"
    t.string   "horario_trabajo_1"
    t.string   "horario_trabajo_3"
    t.string   "horario_trabajo_2"
    t.string   "vencimiento_registro_medico"
    t.string   "vencimiento_bls"
    t.string   "vencimiento_pals"
    t.string   "otros"
    t.string   "bls"
    t.string   "pals"
    t.string   "nombre_presidente_club"
    t.string   "celular_presidente_club"
    t.string   "correo_presidente_club"
  end

  add_index "colaboradores", ["especialidad_id"], name: "index_colaboradores_on_especialidad_id", using: :btree
  add_index "colaboradores", ["persona_id"], name: "index_colaboradores_on_persona_id", using: :btree
  add_index "colaboradores", ["tipo_colaborador_id"], name: "index_colaboradores_on_tipo_colaborador_id", using: :btree

  create_table "compra_cuotas", force: true do |t|
    t.integer  "compra_id"
    t.integer  "nro_cuota"
    t.float    "monto"
    t.date     "fecha_vencimiento"
    t.datetime "fecha_cobro"
    t.boolean  "cancelado",         default: false
    t.string   "nro_recibo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "estado"
  end

  add_index "compra_cuotas", ["compra_id"], name: "index_compra_cuotas_on_compra_id", using: :btree

  create_table "compra_detalles", force: true do |t|
    t.integer  "compra_id"
    t.integer  "producto_id"
    t.integer  "cantidad"
    t.float    "precio_compra"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lote_id"
    t.integer  "contenedor_id"
  end

  add_index "compra_detalles", ["compra_id"], name: "index_compra_detalles_on_compra_id", using: :btree
  add_index "compra_detalles", ["contenedor_id"], name: "index_compra_detalles_on_contenedor_id", using: :btree
  add_index "compra_detalles", ["lote_id"], name: "index_compra_detalles_on_lote_id", using: :btree
  add_index "compra_detalles", ["producto_id"], name: "index_compra_detalles_on_producto_id", using: :btree

  create_table "compra_medios", force: true do |t|
    t.integer  "compra_id"
    t.integer  "tarjeta_id"
    t.integer  "medio_pago_id"
    t.string   "nro_cheque"
    t.integer  "cuenta_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "compra_medios", ["compra_id"], name: "index_compra_medios_on_compra_id", using: :btree
  add_index "compra_medios", ["cuenta_id"], name: "index_compra_medios_on_cuenta_id", using: :btree
  add_index "compra_medios", ["medio_pago_id"], name: "index_compra_medios_on_medio_pago_id", using: :btree
  add_index "compra_medios", ["tarjeta_id"], name: "index_compra_medios_on_tarjeta_id", using: :btree

  create_table "compras", force: true do |t|
    t.integer  "sucursal_id"
    t.integer  "proveedor_id"
    t.float    "total"
    t.float    "iva10"
    t.float    "iva5"
    t.boolean  "credito"
    t.boolean  "pagado"
    t.integer  "cantidad_cuotas"
    t.string   "nro_factura"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo_credito_id"
    t.datetime "fecha_registro"
    t.float    "deuda"
    t.integer  "deposito_id"
    t.float    "retencioniva"
    t.integer  "moneda_id"
    t.integer  "cotizacion_id"
    t.float    "monto_cotizacion"
    t.boolean  "donacion"
    t.string   "nro_orden_compra"
    t.integer  "campanha_id"
    t.integer  "sponsor_id"
  end

  add_index "compras", ["campanha_id"], name: "index_compras_on_campanha_id", using: :btree
  add_index "compras", ["cotizacion_id"], name: "index_compras_on_cotizacion_id", using: :btree
  add_index "compras", ["deposito_id"], name: "index_compras_on_deposito_id", using: :btree
  add_index "compras", ["moneda_id"], name: "index_compras_on_moneda_id", using: :btree
  add_index "compras", ["proveedor_id"], name: "index_compras_on_proveedor_id", using: :btree
  add_index "compras", ["sponsor_id"], name: "index_compras_on_sponsor_id", using: :btree
  add_index "compras", ["sucursal_id"], name: "index_compras_on_sucursal_id", using: :btree
  add_index "compras", ["tipo_credito_id"], name: "index_compras_on_tipo_credito_id", using: :btree

  create_table "consulta_detalles", force: true do |t|
    t.integer  "consulta_id"
    t.float    "cantidad"
    t.integer  "producto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "consentimiento_firmado", default: false
    t.integer  "id_ficha"
    t.string   "referencia_id"
    t.string   "referencia_nombre"
    t.string   "estado"
    t.datetime "fecha_inicio"
    t.datetime "fecha_fin"
  end

  add_index "consulta_detalles", ["consulta_id"], name: "index_consulta_detalles_on_consulta_id", using: :btree
  add_index "consulta_detalles", ["producto_id"], name: "index_consulta_detalles_on_producto_id", using: :btree

  create_table "consultas", force: true do |t|
    t.integer  "colaborador_id"
    t.integer  "especialidad_id"
    t.datetime "fecha_agenda"
    t.datetime "fecha_inicio"
    t.datetime "fecha_fin"
    t.string   "estado"
    t.boolean  "cobrar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "edad",            default: 0.0
    t.integer  "paciente_id"
    t.string   "evaluacion"
    t.string   "diagnostico"
    t.text     "receta"
    t.text     "indicaciones"
    t.integer  "nro_ficha"
  end

  add_index "consultas", ["colaborador_id"], name: "index_consultas_on_colaborador_id", using: :btree
  add_index "consultas", ["especialidad_id"], name: "index_consultas_on_especialidad_id", using: :btree
  add_index "consultas", ["paciente_id"], name: "index_consultas_on_paciente_id", using: :btree

  create_table "consultorios", force: true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.integer  "especialidad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consultorios", ["especialidad_id"], name: "index_consultorios_on_especialidad_id", using: :btree

  create_table "contacto_detalles", force: true do |t|
    t.integer  "contacto_id"
    t.string   "estado"
    t.string   "observacion"
    t.float    "compromiso"
    t.string   "comentario"
    t.datetime "fecha"
    t.datetime "fecha_siguiente"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "moneda_id"
  end

  add_index "contacto_detalles", ["contacto_id"], name: "index_contacto_detalles_on_contacto_id", using: :btree
  add_index "contacto_detalles", ["moneda_id"], name: "index_contacto_detalles_on_moneda_id", using: :btree

  create_table "contactos", force: true do |t|
    t.string   "observacion"
    t.datetime "fecha"
    t.integer  "sponsor_id"
    t.integer  "tipo_contacto_id"
    t.integer  "campanha_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contactos", ["campanha_id"], name: "index_contactos_on_campanha_id", using: :btree
  add_index "contactos", ["sponsor_id"], name: "index_contactos_on_sponsor_id", using: :btree
  add_index "contactos", ["tipo_contacto_id"], name: "index_contactos_on_tipo_contacto_id", using: :btree

  create_table "contenedores", force: true do |t|
    t.string   "nombre"
    t.string   "codigo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conyugues", force: true do |t|
    t.string   "nombre"
    t.string   "apellido"
    t.string   "nacionalidad"
    t.string   "cedula"
    t.date     "fecha_nacimiento"
    t.string   "lugar_nacimiento"
    t.string   "empleador"
    t.string   "actividad_empleador"
    t.string   "cargo"
    t.string   "profesion"
    t.float    "ingreso_mensual"
    t.string   "concepto_otros_ingresos"
    t.float    "otros_ingresos"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cotizaciones", force: true do |t|
    t.decimal  "monto"
    t.datetime "fecha_hora"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "moneda_id"
    t.integer  "usuario_id"
    t.integer  "moneda_base_id"
  end

  add_index "cotizaciones", ["moneda_base_id"], name: "index_cotizaciones_on_moneda_base_id", using: :btree
  add_index "cotizaciones", ["moneda_id"], name: "index_cotizaciones_on_moneda_id", using: :btree
  add_index "cotizaciones", ["usuario_id"], name: "index_cotizaciones_on_usuario_id", using: :btree

  create_table "cuentas", force: true do |t|
    t.string   "banco"
    t.string   "nro_cuenta"
    t.integer  "moneda_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cuentas", ["moneda_id"], name: "index_cuentas_on_moneda_id", using: :btree

  create_table "curso_colaboradores", force: true do |t|
    t.integer "curso_id"
    t.integer "colaborador_id"
    t.string  "observacion"
  end

  add_index "curso_colaboradores", ["colaborador_id"], name: "index_curso_colaboradores_on_colaborador_id", using: :btree
  add_index "curso_colaboradores", ["curso_id"], name: "index_curso_colaboradores_on_curso_id", using: :btree

  create_table "cursos", force: true do |t|
    t.string   "descripcion"
    t.string   "observaciones"
    t.datetime "fecha_inicio"
    t.datetime "fecha_fin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lugar"
  end

  create_table "depositos", force: true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documentos", force: true do |t|
    t.integer  "cliente_id"
    t.integer  "tipo_documento_id"
    t.string   "nombre"
    t.string   "estado"
    t.string   "nombre_archivo"
    t.binary   "archivo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "adjunto_file_name"
    t.string   "adjunto_content_type"
    t.integer  "adjunto_file_size"
    t.datetime "adjunto_updated_at"
    t.string   "adjunto_uuid"
  end

  add_index "documentos", ["cliente_id"], name: "index_documentos_on_cliente_id", using: :btree
  add_index "documentos", ["tipo_documento_id"], name: "index_documentos_on_tipo_documento_id", using: :btree

  create_table "empresas", force: true do |t|
    t.string   "nombre"
    t.boolean  "activo"
    t.string   "ruc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "codigo"
  end

  add_index "empresas", ["nombre"], name: "index_empresas_on_nombre", unique: true, using: :btree

  create_table "especialidades", force: true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "habilita_consulta", default: false
  end

  create_table "eventos", force: true do |t|
    t.string   "tipo"
    t.string   "observacion"
    t.date     "fecha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_id"
  end

  add_index "eventos", ["usuario_id"], name: "index_eventos_on_usuario_id", using: :btree

# Could not dump table "fichas_cirugia" because of following StandardError
#   Unknown type 'jsonb' for column 'tratamientos_realizados'

# Could not dump table "fichas_fonoaudiologia" because of following StandardError
#   Unknown type 'jsonb' for column 'comunicacion_lenguaje'

# Could not dump table "fichas_nutricion" because of following StandardError
#   Unknown type 'jsonb' for column 'datos'

# Could not dump table "fichas_odontologia" because of following StandardError
#   Unknown type 'jsonb' for column 'recien_nacido'

  create_table "fichas_psicologia", force: true do |t|
    t.integer  "paciente_id"
    t.integer  "nro_ficha"
    t.string   "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comentarios"
    t.string   "confidencial"
  end

  add_index "fichas_psicologia", ["paciente_id"], name: "index_fichas_psicologia_on_paciente_id", using: :btree

  create_table "impresoras", force: true do |t|
    t.string   "nombre"
    t.string   "tipo_documento"
    t.string   "tamanho_hoja"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "caja_impresion_id"
  end

  add_index "impresoras", ["caja_impresion_id"], name: "index_impresoras_on_caja_impresion_id", using: :btree

  create_table "ingreso_familiares", force: true do |t|
    t.float    "ingreso_mensual"
    t.integer  "vinculo_familiar_id"
    t.integer  "cliente_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ingreso_familiares", ["cliente_id"], name: "index_ingreso_familiares_on_cliente_id", using: :btree
  add_index "ingreso_familiares", ["vinculo_familiar_id"], name: "index_ingreso_familiares_on_vinculo_familiar_id", using: :btree

  create_table "inventario_lotes", force: true do |t|
    t.integer  "lote_id"
    t.integer  "inventario_id"
    t.float    "existencia"
    t.float    "existencia_previa"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inventario_lotes", ["inventario_id"], name: "index_inventario_lotes_on_inventario_id", using: :btree
  add_index "inventario_lotes", ["lote_id"], name: "index_inventario_lotes_on_lote_id", using: :btree

  create_table "inventario_productos", force: true do |t|
    t.integer  "existencia"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inventario_id"
    t.integer  "producto_id"
    t.integer  "existencia_previa"
  end

  add_index "inventario_productos", ["inventario_id"], name: "index_inventario_productos_on_inventario_id", using: :btree
  add_index "inventario_productos", ["producto_id"], name: "index_inventario_productos_on_producto_id", using: :btree

  create_table "inventarios", force: true do |t|
    t.date     "fecha_inicio"
    t.date     "fecha_fin"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_id"
    t.integer  "deposito_id"
    t.boolean  "control",      default: false
    t.boolean  "procesado",    default: false
  end

  add_index "inventarios", ["deposito_id"], name: "index_inventarios_on_deposito_id", using: :btree
  add_index "inventarios", ["usuario_id"], name: "index_inventarios_on_usuario_id", using: :btree

  create_table "lote_depositos", force: true do |t|
    t.integer  "lote_id"
    t.integer  "deposito_id"
    t.integer  "producto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cantidad"
    t.integer  "contenedor_id"
  end

  add_index "lote_depositos", ["contenedor_id"], name: "index_lote_depositos_on_contenedor_id", using: :btree
  add_index "lote_depositos", ["deposito_id"], name: "index_lote_depositos_on_deposito_id", using: :btree
  add_index "lote_depositos", ["lote_id"], name: "index_lote_depositos_on_lote_id", using: :btree
  add_index "lote_depositos", ["producto_id"], name: "index_lote_depositos_on_producto_id", using: :btree

  create_table "lotes", force: true do |t|
    t.integer  "producto_id"
    t.datetime "fecha_vencimiento"
    t.string   "codigo_lote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lotes", ["producto_id"], name: "index_lotes_on_producto_id", using: :btree

  create_table "medio_pagos", force: true do |t|
    t.string   "nombre"
    t.string   "codigo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activo"
    t.boolean  "registra_pago"
    t.integer  "dias_hasta_pago"
  end

  create_table "monedas", force: true do |t|
    t.string   "nombre"
    t.string   "simbolo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "anulado"
    t.boolean  "redondeo",   default: false
  end

  create_table "motivos_inventarios", force: true do |t|
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "codigo"
  end

  create_table "movimientos", force: true do |t|
    t.integer  "caja_id"
    t.integer  "operacion_id"
    t.integer  "tipo_operacion_detalle_id"
    t.integer  "moneda_id"
    t.float    "monto"
    t.float    "monto_cotizado"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "fecha"
    t.float    "saldo"
  end

  add_index "movimientos", ["caja_id"], name: "index_movimientos_on_caja_id", using: :btree
  add_index "movimientos", ["moneda_id"], name: "index_movimientos_on_moneda_id", using: :btree
  add_index "movimientos", ["operacion_id"], name: "index_movimientos_on_operacion_id", using: :btree
  add_index "movimientos", ["tipo_operacion_detalle_id"], name: "index_movimientos_on_tipo_operacion_detalle_id", using: :btree

  create_table "operaciones", force: true do |t|
    t.float    "monto"
    t.integer  "caja_id"
    t.integer  "caja_destino_id"
    t.integer  "moneda_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "fecha"
    t.integer  "referencia_id"
    t.integer  "tipo_operacion_id"
    t.boolean  "reversado",              default: false
    t.integer  "categoria_operacion_id"
  end

  add_index "operaciones", ["caja_destino_id"], name: "index_operaciones_on_caja_destino_id", using: :btree
  add_index "operaciones", ["caja_id"], name: "index_operaciones_on_caja_id", using: :btree
  add_index "operaciones", ["categoria_operacion_id"], name: "index_operaciones_on_categoria_operacion_id", using: :btree
  add_index "operaciones", ["moneda_id"], name: "index_operaciones_on_moneda_id", using: :btree
  add_index "operaciones", ["tipo_operacion_id"], name: "index_operaciones_on_tipo_operacion_id", using: :btree

# Could not dump table "pacientes" because of following StandardError
#   Unknown type 'jsonb' for column 'datos_familiares'

  create_table "pago_detalles", force: true do |t|
    t.float    "monto_cuota"
    t.float    "monto_interes"
    t.float    "monto_interes_moratorio"
    t.float    "monto_interes_punitorio"
    t.integer  "pago_id"
    t.integer  "compra_cuota_id"
    t.integer  "venta_cuota_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pago_detalles", ["compra_cuota_id"], name: "index_pago_detalles_on_compra_cuota_id", using: :btree
  add_index "pago_detalles", ["pago_id"], name: "index_pago_detalles_on_pago_id", using: :btree
  add_index "pago_detalles", ["venta_cuota_id"], name: "index_pago_detalles_on_venta_cuota_id", using: :btree

  create_table "pagos", force: true do |t|
    t.date     "fecha_pago"
    t.string   "estado"
    t.date     "fecha_actualizacion_interes"
    t.float    "total"
    t.float    "monto_cotizacion"
    t.integer  "venta_id"
    t.integer  "compra_id"
    t.integer  "moneda_id"
    t.boolean  "borrado"
    t.float    "descuento"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_solicitud_descuento_id"
    t.integer  "usuario_aprobacion_descuento_id"
    t.float    "total_moneda_seleccionada"
    t.float    "descuento_moneda_seleccionada"
    t.string   "banco_cheque"
    t.string   "numero_cheque"
    t.string   "nro_recibo"
  end

  add_index "pagos", ["compra_id"], name: "index_pagos_on_compra_id", using: :btree
  add_index "pagos", ["moneda_id"], name: "index_pagos_on_moneda_id", using: :btree
  add_index "pagos", ["usuario_aprobacion_descuento_id"], name: "index_pagos_on_usuario_aprobacion_descuento_id", using: :btree
  add_index "pagos", ["usuario_solicitud_descuento_id"], name: "index_pagos_on_usuario_solicitud_descuento_id", using: :btree
  add_index "pagos", ["venta_id"], name: "index_pagos_on_venta_id", using: :btree

  create_table "parametros_empresas", force: true do |t|
    t.boolean  "imei_en_venta_detalle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "empresa_id"
    t.boolean  "soporta_sucursales",              default: false
    t.boolean  "soporta_multiempresa",            default: false
    t.boolean  "vendedor_en_venta"
    t.boolean  "tarjeta_credito_en_venta"
    t.boolean  "soporta_caja_impresion"
    t.integer  "retencioniva"
    t.boolean  "soporta_uso_interno"
    t.boolean  "soporta_ajuste_inventario"
    t.boolean  "soporta_multimoneda"
    t.integer  "moneda_id"
    t.integer  "moneda_base_id"
    t.boolean  "default_empresa"
    t.boolean  "recargo_precio_venta"
    t.boolean  "ctrl_inventario_set_existencia"
    t.integer  "ctrl_inventario_cantidad"
    t.boolean  "imprimir_remision"
    t.boolean  "sequences_por_empresa"
    t.integer  "sucursal_default_id"
    t.boolean  "soporta_cajas",                   default: false
    t.boolean  "soporta_impresion_factura_venta", default: true
    t.boolean  "soporta_parametro_caliente",      default: false
    t.boolean  "soporta_garante_venta",           default: false
    t.boolean  "soporta_produccion",              default: false
    t.boolean  "soporta_impresion_recibo",        default: false
    t.boolean  "soporta_medicamentos",            default: false
    t.integer  "max_detalles_ventas",             default: 30
    t.float    "monto_alivio"
    t.boolean  "cierre_automatico_caja",          default: true
    t.boolean  "permite_promociones",             default: true
  end

  add_index "parametros_empresas", ["empresa_id"], name: "index_parametros_empresas_on_empresa_id", using: :btree
  add_index "parametros_empresas", ["moneda_base_id"], name: "index_parametros_empresas_on_moneda_base_id", using: :btree
  add_index "parametros_empresas", ["moneda_id"], name: "index_parametros_empresas_on_moneda_id", using: :btree
  add_index "parametros_empresas", ["sucursal_default_id"], name: "index_parametros_empresas_on_sucursal_default_id", using: :btree

  create_table "personas", force: true do |t|
    t.string   "nombre"
    t.string   "apellido"
    t.string   "ci_ruc"
    t.string   "razon_social"
    t.string   "tipo_persona"
    t.string   "sexo"
    t.string   "estado_civil"
    t.string   "nacionalidad"
    t.string   "telefono"
    t.string   "celular"
    t.string   "correo"
    t.integer  "ciudad_id"
    t.string   "barrio"
    t.string   "direccion"
    t.string   "tipo_domicilio"
    t.float    "antiguedad_domicilio"
    t.string   "fecha_nacimiento"
    t.string   "date"
    t.integer  "numero_hijos"
    t.string   "estudios_realizados"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conyugue_id"
    t.integer  "edad"
  end

  add_index "personas", ["conyugue_id"], name: "index_personas_on_conyugue_id", using: :btree

  create_table "precios", force: true do |t|
    t.datetime "fecha"
    t.float    "precio_compra"
    t.integer  "compra_detalle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "precios", ["compra_detalle_id"], name: "index_precios_on_compra_detalle_id", using: :btree

  create_table "proceso_detalles", force: true do |t|
    t.integer  "proceso_id"
    t.integer  "producto_id"
    t.integer  "cantidad"
    t.float    "precio_costo"
    t.float    "precio_venta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proceso_detalles", ["proceso_id"], name: "index_proceso_detalles_on_proceso_id", using: :btree
  add_index "proceso_detalles", ["producto_id"], name: "index_proceso_detalles_on_producto_id", using: :btree

  create_table "procesos", force: true do |t|
    t.integer  "producto_id"
    t.integer  "cantidad"
    t.string   "descripcion"
    t.string   "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "procesos", ["producto_id"], name: "index_procesos_on_producto_id", using: :btree

  create_table "produccion_detalles", force: true do |t|
    t.integer  "produccion_id"
    t.integer  "producto_id"
    t.integer  "lote_id"
    t.integer  "deposito_id"
    t.integer  "cantidad"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "produccion_detalles", ["deposito_id"], name: "index_produccion_detalles_on_deposito_id", using: :btree
  add_index "produccion_detalles", ["lote_id"], name: "index_produccion_detalles_on_lote_id", using: :btree
  add_index "produccion_detalles", ["produccion_id"], name: "index_produccion_detalles_on_produccion_id", using: :btree
  add_index "produccion_detalles", ["producto_id"], name: "index_produccion_detalles_on_producto_id", using: :btree

  create_table "producciones", force: true do |t|
    t.integer  "producto_id"
    t.integer  "cantidad_produccion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposito_id"
  end

  add_index "producciones", ["deposito_id"], name: "index_producciones_on_deposito_id", using: :btree
  add_index "producciones", ["producto_id"], name: "index_producciones_on_producto_id", using: :btree

  create_table "producto_depositos", force: true do |t|
    t.integer  "producto_id"
    t.integer  "deposito_id"
    t.integer  "existencia"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "producto_depositos", ["deposito_id"], name: "index_producto_depositos_on_deposito_id", using: :btree
  add_index "producto_depositos", ["producto_id"], name: "index_producto_depositos_on_producto_id", using: :btree

  create_table "producto_detalles", force: true do |t|
    t.integer  "producto_id"
    t.integer  "producto_padre_id"
    t.integer  "cantidad"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "producto_detalles", ["producto_id"], name: "index_producto_detalles_on_producto_id", using: :btree
  add_index "producto_detalles", ["producto_padre_id"], name: "index_producto_detalles_on_producto_padre_id", using: :btree

  create_table "productos", force: true do |t|
    t.string   "codigo_barra"
    t.text     "descripcion"
    t.string   "unidad"
    t.float    "margen"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "iva"
    t.float    "precio_compra"
    t.float    "precio"
    t.integer  "stock_minimo"
    t.float    "precio_promedio"
    t.boolean  "activo"
    t.boolean  "pack"
    t.integer  "cantidad"
    t.integer  "producto_id"
    t.string   "foto_file_name"
    t.string   "foto_content_type"
    t.integer  "foto_file_size"
    t.datetime "foto_updated_at"
    t.integer  "moneda_id"
    t.boolean  "servicio",                        default: false
    t.string   "codigo_externo"
    t.text     "descripcion_externa"
    t.string   "codigo_local"
    t.integer  "tipo_producto_id"
    t.text     "descripcion_local"
    t.integer  "especialidad_id"
    t.boolean  "es_procedimiento",                default: false
    t.string   "marca"
    t.string   "presentacion"
    t.boolean  "necesita_consentimiento_firmado", default: false
    t.string   "nro_inventario"
    t.string   "nro_serie"
    t.string   "asignado"
    t.string   "responsable_mantenimiento"
    t.string   "anho_fabricacion"
    t.datetime "fecha_adquisicion"
    t.string   "area"
    t.string   "modelo"
    t.boolean  "descontinuado",                   default: false
    t.string   "nro_referencia"
  end

  add_index "productos", ["codigo_barra"], name: "index_productos_on_codigo_barra", using: :btree
  add_index "productos", ["especialidad_id"], name: "index_productos_on_especialidad_id", using: :btree
  add_index "productos", ["moneda_id"], name: "index_productos_on_moneda_id", using: :btree
  add_index "productos", ["producto_id"], name: "index_productos_on_producto_id", using: :btree
  add_index "productos", ["tipo_producto_id"], name: "index_productos_on_tipo_producto_id", using: :btree

  create_table "promocion_productos", force: true do |t|
    t.float    "cantidad"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "promocion_id"
    t.integer  "producto_id"
    t.float    "precio_descuento"
    t.boolean  "porcentaje"
    t.integer  "moneda_id"
    t.boolean  "caliente",         default: false
  end

  add_index "promocion_productos", ["moneda_id"], name: "index_promocion_productos_on_moneda_id", using: :btree
  add_index "promocion_productos", ["producto_id"], name: "index_promocion_productos_on_producto_id", using: :btree
  add_index "promocion_productos", ["promocion_id"], name: "index_promocion_productos_on_promocion_id", using: :btree

  create_table "promociones", force: true do |t|
    t.text     "descripcion"
    t.date     "fecha_vigencia_desde"
    t.date     "fecha_vigencia_hasta"
    t.float    "porcentaje_descuento"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "permanente"
    t.boolean  "exclusiva"
    t.integer  "cantidad_general"
    t.integer  "tarjeta_id"
    t.boolean  "con_tarjeta",          default: false
    t.boolean  "activo",               default: true
    t.boolean  "a_partir_de",          default: false
    t.boolean  "por_unidad",           default: true
  end

  add_index "promociones", ["tarjeta_id"], name: "index_promociones_on_tarjeta_id", using: :btree

  create_table "proveedor_productos", force: true do |t|
    t.integer  "proveedor_id"
    t.integer  "producto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proveedor_productos", ["producto_id"], name: "index_proveedor_productos_on_producto_id", using: :btree
  add_index "proveedor_productos", ["proveedor_id"], name: "index_proveedor_productos_on_proveedor_id", using: :btree

  create_table "proveedores", force: true do |t|
    t.string   "razon_social"
    t.string   "ruc"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "email"
    t.string   "persona_contacto"
    t.string   "telefono_contacto"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recargos", force: true do |t|
    t.integer  "cantidad_cuotas"
    t.float    "interes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo_credito_id"
    t.integer  "medio_pago_id"
  end

  add_index "recargos", ["medio_pago_id"], name: "index_recargos_on_medio_pago_id", using: :btree
  add_index "recargos", ["tipo_credito_id"], name: "index_recargos_on_tipo_credito_id", using: :btree

  create_table "recursos", force: true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recursos_roles", force: true do |t|
    t.integer  "rol_id"
    t.integer  "recurso_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recursos_roles", ["recurso_id"], name: "index_recursos_roles_on_recurso_id", using: :btree
  add_index "recursos_roles", ["rol_id"], name: "index_recursos_roles_on_rol_id", using: :btree

  create_table "referencias", force: true do |t|
    t.integer  "cliente_id"
    t.string   "nombre"
    t.string   "telefono"
    t.string   "tipo_referencia"
    t.string   "tipo_cuenta"
    t.boolean  "activa"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "referencias", ["cliente_id"], name: "index_referencias_on_cliente_id", using: :btree

  create_table "registros_produccion", force: true do |t|
    t.integer  "proceso_id"
    t.integer  "cantidad"
    t.string   "estado"
    t.date     "fecha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposito_id"
    t.text     "observacion"
  end

  add_index "registros_produccion", ["deposito_id"], name: "index_registros_produccion_on_deposito_id", using: :btree
  add_index "registros_produccion", ["proceso_id"], name: "index_registros_produccion_on_proceso_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_usuarios", force: true do |t|
    t.integer  "rol_id"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles_usuarios", ["rol_id"], name: "index_roles_usuarios_on_rol_id", using: :btree
  add_index "roles_usuarios", ["usuario_id"], name: "index_roles_usuarios_on_usuario_id", using: :btree

  create_table "sponsors", force: true do |t|
    t.integer  "persona_id"
    t.string   "segmento"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activo"
    t.string   "contacto_nombre"
    t.string   "contacto_apellido"
    t.string   "contacto_celular"
    t.string   "contacto_cargo"
    t.string   "contacto_email"
    t.string   "tipo_sponsor"
  end

  add_index "sponsors", ["persona_id"], name: "index_sponsors_on_persona_id", using: :btree

  create_table "sucursales", force: true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activo"
    t.integer  "empresa_id"
    t.integer  "deposito_id"
    t.string   "color",       limit: 10
    t.integer  "vendedor_id"
  end

  add_index "sucursales", ["deposito_id"], name: "index_sucursales_on_deposito_id", using: :btree
  add_index "sucursales", ["empresa_id"], name: "index_sucursales_on_empresa_id", using: :btree
  add_index "sucursales", ["vendedor_id"], name: "index_sucursales_on_vendedor_id", using: :btree

  create_table "sucursales_usuarios", force: true do |t|
    t.integer "usuario_id"
    t.integer "sucursal_id"
  end

  add_index "sucursales_usuarios", ["sucursal_id"], name: "index_sucursales_usuarios_on_sucursal_id", using: :btree
  add_index "sucursales_usuarios", ["usuario_id"], name: "index_sucursales_usuarios_on_usuario_id", using: :btree

  create_table "sucursales_vendedores", force: true do |t|
    t.integer  "sucursal_id"
    t.integer  "vendedor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sucursales_vendedores", ["sucursal_id"], name: "index_sucursales_vendedores_on_sucursal_id", using: :btree
  add_index "sucursales_vendedores", ["vendedor_id"], name: "index_sucursales_vendedores_on_vendedor_id", using: :btree

  create_table "tarjetas", force: true do |t|
    t.string   "banco"
    t.string   "marca"
    t.string   "afinidad"
    t.integer  "medio_pago_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activo"
  end

  add_index "tarjetas", ["medio_pago_id"], name: "index_tarjetas_on_medio_pago_id", using: :btree

  create_table "tipo_campanhas", force: true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_colaboradores", force: true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.boolean  "tiene_viajes"
    t.boolean  "tiene_licencia"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "es_club",        default: false
  end

  create_table "tipo_contactos", force: true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.boolean  "con_campanha"
    t.boolean  "con_mision"
    t.boolean  "activo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_creditos", force: true do |t|
    t.string   "descripcion"
    t.integer  "plazo"
    t.string   "unidad_tiempo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_documentos", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tipo_documentos", ["nombre"], name: "index_tipo_documentos_on_nombre", unique: true, using: :btree

  create_table "tipo_operacion_detalles", force: true do |t|
    t.integer  "tipo_operacion_id"
    t.string   "descripcion"
    t.integer  "tipo_movimiento_id"
    t.boolean  "caja_destino"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "impacta_saldo",      default: false
    t.boolean  "genera_diferencia",  default: false
    t.integer  "secuencia",          default: 1
  end

  add_index "tipo_operacion_detalles", ["tipo_movimiento_id"], name: "index_tipo_operacion_detalles_on_tipo_movimiento_id", using: :btree
  add_index "tipo_operacion_detalles", ["tipo_operacion_id"], name: "index_tipo_operacion_detalles_on_tipo_operacion_id", using: :btree

  create_table "tipo_productos", force: true do |t|
    t.string  "descripcion"
    t.string  "codigo"
    t.boolean "usa_lote"
    t.boolean "procedimiento"
    t.boolean "especialidad"
    t.boolean "stock"
    t.boolean "producto_osi"
  end

  create_table "tipo_salidas", force: true do |t|
    t.string  "codigo"
    t.string  "descripcion"
    t.boolean "muestra_medios_pago", default: false
  end

  create_table "tipo_sponsors", force: true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipos_movimiento", force: true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipos_operacion", force: true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.boolean  "manual"
    t.string   "referencia"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tipo_operacion_reversion"
    t.boolean  "muestra_saldo",            default: false
    t.string   "caja_default",             default: "usuario"
    t.boolean  "operacion_basica",         default: false
    t.boolean  "externo",                  default: false
  end

  create_table "transferencia_deposito_detalles", force: true do |t|
    t.integer  "transferencia_id"
    t.integer  "cantidad"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lote_id"
  end

  add_index "transferencia_deposito_detalles", ["lote_id"], name: "index_transferencia_deposito_detalles_on_lote_id", using: :btree
  add_index "transferencia_deposito_detalles", ["transferencia_id"], name: "index_transferencia_deposito_detalles_on_transferencia_id", using: :btree

  create_table "transferencias_deposito", force: true do |t|
    t.integer  "origen_id"
    t.integer  "destino_id"
    t.integer  "usuario_id"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "fecha_registro"
    t.string   "nro_transferencia"
  end

  add_index "transferencias_deposito", ["destino_id"], name: "index_transferencias_deposito_on_destino_id", using: :btree
  add_index "transferencias_deposito", ["origen_id"], name: "index_transferencias_deposito_on_origen_id", using: :btree
  add_index "transferencias_deposito", ["usuario_id"], name: "index_transferencias_deposito_on_usuario_id", using: :btree

  create_table "tratamientos", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "especialidad_id"
  end

  add_index "tratamientos", ["especialidad_id"], name: "index_tratamientos_on_especialidad_id", using: :btree

  create_table "usuarios", force: true do |t|
    t.string   "nombre"
    t.string   "apellido"
    t.string   "email"
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "usuarios", ["email"], name: "index_usuarios_on_email", unique: true, using: :btree
  add_index "usuarios", ["username"], name: "index_usuarios_on_username", unique: true, using: :btree

  create_table "vendedores", force: true do |t|
    t.string   "nombre"
    t.string   "apellido"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activo"
    t.float    "comision",   default: 0.0
  end

  create_table "venta_cuotas", force: true do |t|
    t.integer  "venta_id",                          null: false
    t.integer  "nro_cuota"
    t.float    "monto"
    t.date     "fecha_vencimiento"
    t.date     "fecha_cobro"
    t.boolean  "cancelado",         default: false
    t.string   "nro_recibo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "estado"
  end

  add_index "venta_cuotas", ["venta_id"], name: "index_venta_cuotas_on_venta_id", using: :btree

  create_table "venta_detalles", force: true do |t|
    t.integer  "venta_id"
    t.integer  "producto_id",                      null: false
    t.integer  "cantidad"
    t.float    "precio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "descuento",        default: 0.0
    t.boolean  "caliente",         default: false
    t.integer  "promocion_id"
    t.string   "imei"
    t.integer  "cotizacion_id"
    t.float    "monto_cotizacion"
    t.integer  "moneda_id"
    t.integer  "lote_id"
  end

  add_index "venta_detalles", ["cotizacion_id"], name: "index_venta_detalles_on_cotizacion_id", using: :btree
  add_index "venta_detalles", ["lote_id"], name: "index_venta_detalles_on_lote_id", using: :btree
  add_index "venta_detalles", ["moneda_id"], name: "index_venta_detalles_on_moneda_id", using: :btree
  add_index "venta_detalles", ["producto_id"], name: "index_venta_detalles_on_producto_id", using: :btree
  add_index "venta_detalles", ["promocion_id"], name: "index_venta_detalles_on_promocion_id", using: :btree
  add_index "venta_detalles", ["venta_id"], name: "index_venta_detalles_on_venta_id", using: :btree

  create_table "venta_medios", force: true do |t|
    t.integer  "venta_id",      null: false
    t.integer  "medio_pago_id", null: false
    t.float    "monto"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tarjeta_id"
  end

  add_index "venta_medios", ["medio_pago_id"], name: "index_venta_medios_on_medio_pago_id", using: :btree
  add_index "venta_medios", ["tarjeta_id"], name: "index_venta_medios_on_tarjeta_id", using: :btree
  add_index "venta_medios", ["venta_id"], name: "index_venta_medios_on_venta_id", using: :btree

  create_table "ventas", force: true do |t|
    t.integer  "cliente_id"
    t.float    "descuento"
    t.float    "total"
    t.float    "iva10"
    t.float    "iva5"
    t.boolean  "credito"
    t.boolean  "pagado"
    t.string   "nro_factura"
    t.integer  "cantidad_cuotas",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "fecha_registro"
    t.integer  "tipo_credito_id"
    t.integer  "sucursal_id"
    t.float    "deuda"
    t.float    "ganancia"
    t.boolean  "anulado",            default: false
    t.datetime "deleted_at"
    t.string   "supervisor"
    t.boolean  "uso_interno"
    t.float    "descuento_redondeo", default: 0.0
    t.boolean  "tarjeta_credito"
    t.integer  "vendedor_id"
    t.string   "nombre_cliente"
    t.string   "ruc_cliente"
    t.integer  "moneda_id"
    t.integer  "medio_pago_id"
    t.integer  "tarjeta_id"
    t.float    "porcentaje_recargo"
    t.string   "nro_contrato"
    t.integer  "garante_id"
    t.integer  "usuario_id"
    t.integer  "venta_padre_id"
    t.integer  "campanha_id"
    t.integer  "tipo_salida_id"
    t.integer  "persona_id"
    t.integer  "colaborador_id"
    t.integer  "consultorio_id"
    t.boolean  "cirugia",            default: false
    t.integer  "cantidad_cirugias"
  end

  add_index "ventas", ["campanha_id"], name: "index_ventas_on_campanha_id", using: :btree
  add_index "ventas", ["cliente_id"], name: "index_ventas_on_cliente_id", using: :btree
  add_index "ventas", ["colaborador_id"], name: "index_ventas_on_colaborador_id", using: :btree
  add_index "ventas", ["consultorio_id"], name: "index_ventas_on_consultorio_id", using: :btree
  add_index "ventas", ["garante_id"], name: "index_ventas_on_garante_id", using: :btree
  add_index "ventas", ["medio_pago_id"], name: "index_ventas_on_medio_pago_id", using: :btree
  add_index "ventas", ["moneda_id"], name: "index_ventas_on_moneda_id", using: :btree
  add_index "ventas", ["persona_id"], name: "index_ventas_on_persona_id", using: :btree
  add_index "ventas", ["sucursal_id"], name: "index_ventas_on_sucursal_id", using: :btree
  add_index "ventas", ["tarjeta_id"], name: "index_ventas_on_tarjeta_id", using: :btree
  add_index "ventas", ["tipo_credito_id"], name: "index_ventas_on_tipo_credito_id", using: :btree
  add_index "ventas", ["tipo_salida_id"], name: "index_ventas_on_tipo_salida_id", using: :btree
  add_index "ventas", ["usuario_id"], name: "index_ventas_on_usuario_id", using: :btree
  add_index "ventas", ["vendedor_id"], name: "index_ventas_on_vendedor_id", using: :btree

  create_table "viaje_colaboradores", force: true do |t|
    t.integer  "viaje_id"
    t.integer  "colaborador_id"
    t.float    "costo_ticket"
    t.float    "costo_estadia"
    t.string   "companhia"
    t.string   "observacion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "viaje_colaboradores", ["colaborador_id"], name: "index_viaje_colaboradores_on_colaborador_id", using: :btree
  add_index "viaje_colaboradores", ["viaje_id"], name: "index_viaje_colaboradores_on_viaje_id", using: :btree

  create_table "viajes", force: true do |t|
    t.string   "descripcion"
    t.string   "origen"
    t.string   "destino"
    t.datetime "fecha_inicio"
    t.datetime "fecha_fin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vinculo_familiares", force: true do |t|
    t.string   "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
