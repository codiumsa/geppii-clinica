class AddFuncionParaOrdenarConsultas < ActiveRecord::Migration
  def up
    execute IO.read("Script/funcion_ordenar_consultas.sql")
  end

  def down
    execute "DROP FUNCTION IF EXISTS DateDiff(character varying, timestamp without time zone, timestamp without time zone);"
  end
end
