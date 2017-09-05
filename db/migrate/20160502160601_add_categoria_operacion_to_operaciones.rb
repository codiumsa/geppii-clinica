class AddCategoriaOperacionToOperaciones < ActiveRecord::Migration
  def change
    add_reference :operaciones, :categoria_operacion, index: true

    begin
      say "Insertando categoria operacion default"
      execute <<-SQL 
      	INSERT INTO public.categoria_operaciones 
      	(id, nombre, descripcion, created_at, updated_at, tipo_operacion_id, activo) 
      	VALUES (NEXTVAL('categoria_operaciones_id_seq'), 'otros', 'Otros', now(), now(), null,  true);
      SQL

     #say "Update operaciones con categoria otros"
     #execute <<-SQL
     #	update  o
		 #  set o.categoria_operacion_id = s.id
		 #  from public.operaciones as o join tipos_operacion tope on (o.tipo_operacion_id = tope.id)
		 #  join (select id from categoria_operaciones co where co.nombre = 'otros' and co.tipo_operacion_id is null) s
		 #  where tope.manual = true and tope.operacion_basica = false and o.categoria_operacion_id is null;
    #SQL
    rescue => e
      say "Problemas al asignar la categoria por defecto"
    end
  end
end
