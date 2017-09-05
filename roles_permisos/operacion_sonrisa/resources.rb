def crear_recursos
  recursos_yml_path = "../../test/fixtures/operacionsonrisa/recursos.yml"

  File.delete(recursos_yml_path) if File.exist?(recursos_yml_path)

  permisos_backend = ["BE_index", "BE_show", "BE_post", "BE_put", "BE_delete",
                      "FE_index", "FE_show", "FE_post", "FE_put", "FE_delete", "FE"];
  permisos_campos = ["codigo", "descripcion"]

  File.foreach( 'resources.txt' ) do |recurso|
    puts "Creando recurso: #{recurso}"
    File.open(recursos_yml_path, "a") do |yml|
      permisos_backend.each do |permiso|
        yml.puts "#{permiso}_#{recurso.chomp}:"
        permisos_campos.each do |field|
          yml.puts "  #{field}: #{permiso}_#{recurso}"
        end
      end
    end
  end
end
