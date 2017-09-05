
require 'active_record/fixtures'
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "recursos")
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "roles")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "usuarios")
#
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "depositos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "empresas")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "sucursales")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "parametros_empresas")
#
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/", "ciudades")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "personas")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "medio_pagos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "tarjetas")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "tipo_creditos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "tipo_productos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "cotizaciones")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "recursos")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "roles")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "usuarios")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "sucursales_usuarios")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "tipo_salida")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "monedas")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "especialidades")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "tipo_campanhas")
# ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "tipo_colaboradores")


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
