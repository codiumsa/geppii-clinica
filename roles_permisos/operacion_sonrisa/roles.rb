require_relative 'resources'

crear_recursos()

roles_yml_path = "../../test/fixtures/operacionsonrisa/roles.yml"

File.delete(roles_yml_path) if File.exist?(roles_yml_path)

roles = Dir.entries("roles/").select{|e| e.to_str.end_with?(".csv")}

permisos = ["FE_index", "FE_show", "FE_post", "FE_put", "FE_delete", "BE_index", "Be_show",
            "BE_post", "BE_put", "BE_delete", "FE"]

roles_finales = []
roles.each do |rol|
  puts "Crear rol #{rol}"
  nombre_rol = rol.sub('.csv', '').downcase
  nuevo_rol = "#{nombre_rol}: \n  codigo: #{nombre_rol}\n  descripcion: #{nombre_rol}\n  recursos:"
  permisos_rol = ""

  File.open("roles/#{rol}").each_with_index do |linea, index|
    next if index == 0
    parsed = linea.split(",")

    recurso = parsed[0]
    parsed = parsed[1,11]
    parsed.each_with_index do |asignacion, index|
      asignacion.chomp!
      if asignacion == "S"
        nombre_permiso = "#{permisos[index]}_#{recurso}"
        permisos_rol = permisos_rol == "" ? " #{nombre_permiso}" : "#{permisos_rol}, #{nombre_permiso}"
      end
    end
  end
  roles_finales << "#{nuevo_rol}#{permisos_rol}"
end


File.open(roles_yml_path, "a") do |file|
  roles_finales.each do |nuevo|
    file.puts(nuevo)
  end
end
