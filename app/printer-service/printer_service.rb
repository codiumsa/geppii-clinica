class PrinterService
    
    #-------------viejo método------------------
#	def initialize(firma, pdf)
#		printers = []
#		Settings.printers.printers.each do |p|
#			if p[0] == firma
#				printers.push([p[1], p[2]])
#			end
#		end
#		
#		if printers.length == 0
#			raise "No hay impresora configurada para #esta empresa"
#		end
#		
#		index = (0..(printers.length-1)).to_a.sample	
#		file_name = Time.now.strftime('%Y%m%d%H%M%S%L') #+ (0..10000).to_a.sample.to_s + ".pdf"
#			
#		#puts "\n\n\n\n\nSe imprimira archivo: " + #file_name +  " en impresora: " + printers[index][1] + #" en pagesize " + printers[index][0]
#		pdf.render_file file_name
#		pageSize = printers[index][0]
#		
#		#puts "\n\n\n\n\n\n" + firma
#   ENV['PATH'] = "#{ENV['PATH']}:/usr/bin" 
#		if(firma == "interno")
#			#puts "\n\n\n\n\nSe imprime como interno"
#			system("lpr", "-P", printers[index][1], "-#o", pageSize,file_name) or raise "lpr failed"
#			#system("lpr", "-P", printers[index][1], "-#o", pageSize, "-o", "page-top=0", "-o", "page-bottom=0",file_name) or raise "lpr failed"
#		else
#			#puts "\n\n\n\n\nNo es interno"
#			system("lpr", "-P", printers[index][1], "-#o", pageSize, file_name) or raise "lpr failed"
#		end
#		system("rm", file_name)
#   end	


    #-------------nuevo método------------------
	def initialize(impresora, pdfs)

		if not pdfs.kind_of?(Array)
			pdfs = [pdfs]
		end

		for pdf in pdfs
	        file_name = Time.now.strftime('%Y%m%d%H%M%S%L') #+ (0..10000).to_a.sample.to_s + ".pdf"
			puts "\n\n\n\n\nSe imprimira archivo: " + file_name +  " en impresora: " + impresora.nombre + " en pagesize " + impresora.tamanho_hoja
			pdf.render_file file_name
			pageSize = impresora.tamanho_hoja;
			firma = impresora.tipo_documento;
	        
			puts "\n\n\n\n\n\n" + firma
	    	ENV['PATH'] = "#{ENV['PATH']}:/usr/bin" 
			if(firma == "interno")
				#puts "\n\n\n\n\nSe imprime como interno"
				system("lpr", "-P", impresora.nombre, "-o", pageSize,file_name) or raise "lpr failed"
				#system("lpr", "-P", printers[index][1], "-o", pageSize, "-o", "page-top=0", "-o", "page-bottom=0",file_name) or raise "lpr failed"
			else
				#puts "\n\n\n\n\nNo es interno"
				system("lpr", "-P", impresora.nombre, "-o", pageSize, file_name) or raise "lpr failed"
			end
			system("rm", file_name)
		end
	end	
    

end


