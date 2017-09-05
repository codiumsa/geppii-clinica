namespace :verifica_fecha_vencimiento do

	desc "Se cargan las tareas cron a ser ejecutados regularmente"
	task :fecha_ventas => :environment do
		CompraCuota.vence_cuota
		VentaCuota.vence_cuota
	end
end