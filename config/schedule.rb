# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/Users/javierperez/Desktop/log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

#every 1.minute do
#  runner "CompraCuota.vence_cuota"
#  runner "VentaCuota.vence_cuota"
#end

every "0 8 * * 1" do
	runner "VencimientosMailer.vencimiento_semanal"
	runner "ContactoSponsorsMailer.contacto_sponsors"
end

every "0 8 1 * *" do
	runner "VencimientosMailer.vencimiento_mensual"
end
