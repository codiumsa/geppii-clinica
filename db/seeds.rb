require 'active_record/fixtures'
#
# # #Empresa
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "empresas")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "depositos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "sucursales")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "parametros_empresas")
# # #
# #Defaults
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/", "ciudades")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "tipo_documentos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "vinculo_familiares")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "calificaciones")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "documentos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "ingreso_familiares")
# #
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "personas")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "clientes")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "impresoras")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "medio_pagos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "tarjetas")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "tipo_creditos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "tipo_productos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "cotizaciones")
# #
# #Autorización
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "recursos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "roles")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "usuarios")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "sucursales_usuarios")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "sucursales_vendedores")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "vendedores")

# #
# #Ejemplos
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "categorias")
# #ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "productos")
# #ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "lotes")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "tipo_salida")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "consultorios")

# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/"+ Settings.empresa, "contactos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/"+ Settings.empresa, "tipo_contactos")

# #
# # #
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "ventas")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "venta_detalles")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "venta_cuotas")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "promociones")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "promocion_productos")
# #
# #ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "proveedores")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "compras")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "compra_detalles")
# #
# #ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "inventarios")
# #ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "inventario_lotes")
# #
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "precios")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "compra_cuotas")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "categoria_clientes")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "categoria_cliente_promociones")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "procesos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "vendedores")
# #
# #Clínica
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "especialidades")
# #
# #Campanhas
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "tipo_campanhas")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "campanhas")
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "tipo_colaboradores")
#ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "colaboradores")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "consultas")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "consulta_detalles")


#Creacion de sequence por sucursal
begin
  connection = ActiveRecord::Base.connection();
  puts "======================"
  puts "Creando las SECUENCIAS"
  puts "======================"
  for i in 1..Settings.nro_sucursales[Settings.empresa]
    puts "Secuencia sucursal_#{i}_nro_factura_seq"
    query = "SELECT 0 FROM pg_class where relname = 'sucursal_#{i}_nro_factura_seq'"
    result = connection.select_all(query)
    if(result.rows.size!=1)
      query = "CREATE SEQUENCE sucursal_#{i}_nro_factura_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;"
      connection.execute(query)
      puts "---------> CREADO"
    end

    puts "Secuencia sucursal_#{i}_nro_transferencia_seq"
    query = "SELECT 0 FROM pg_class where relname = 'sucursal_#{i}_nro_transferencia_seq'"
    result = connection.select_all(query)
    if(result.rows.size!=1)
      query2 = "CREATE SEQUENCE sucursal_#{i}_nro_transferencia_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;"
      connection.execute(query2)
      puts "---------> CREADO"
    end
  end

  for i in 1..Settings.nro_empresas
    puts "Secuencia empresa_#{i}_nro_factura_seq"
    query = "SELECT 0 FROM pg_class where relname = 'empresa_#{i}_nro_factura_seq'"
    result = connection.select_all(query)
    if(result.rows.size!=1)
      query3 = "CREATE SEQUENCE empresa_#{i}_nro_factura_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;"
      connection.execute(query3)
      puts "---------> CREADO"
    end
  end

  puts "Creando paciente_nro_paciente_sec.... "
  query4 = "SELECT 0 FROM pg_class where relname = 'paciente_nro_paciente_sec'"
  result = connection.select_all(query4)
  if(result.rows.size!=1)
    query4 = "CREATE SEQUENCE paciente_nro_paciente_sec INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;"
    connection.execute(query4)
    puts "---------> CREADO"
  end

  puts "Creando nro_ficha_sec.... "
  query4 = "SELECT 0 FROM pg_class where relname = 'nro_ficha_sec'"
  result = connection.select_all(query4)
  if(result.rows.size!=1)
    query4 = "CREATE SEQUENCE nro_ficha_sec INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;"
    connection.execute(query4)
    puts "---------> CREADO"
  end

rescue Exception=>e
  puts "===================================="
  puts "No se puedieron crear las SECUENCIAS"
  puts e
  puts "===================================="
end

begin
  puts "========================"
  puts "Creando las FOREIGN KEYS"
  puts "========================"
  creacion de los foreign keys
  connection.execute(IO.read("Script/queryForeignKey.sql"))
rescue Exception=>e
  puts "======================================"
  puts "No se puedieron crear los FOREIGN KEYS"
  puts e
  puts "======================================"
end
