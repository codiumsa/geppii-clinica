# encoding: utf-8
class Inventario < ActiveRecord::Base
	belongs_to :deposito
	belongs_to :usuario
  has_many :inventario_lotes, :dependent => :destroy

	validates :descripcion, :fecha_inicio, :fecha_fin, :deposito_id, presence: true

  scope :by_id, -> id { where("id = ?", "#{id}") }
	scope :by_descripcion, -> descripcion { where("descripcion ilike ?", "%#{descripcion}%") }
  scope :by_deposito_id, -> deposito { where("deposito_id = ?", "#{deposito}") }
	scope :control, -> control { where("control = ?", "#{control}") }
  scope :by_fecha_inicio_before, -> before{ where("fecha_inicio::date < ?", Date.parse(before)) }
  scope :by_fecha_inicio_after, -> after { where("fecha_inicio::date > ?", Date.parse(after)) }
  scope :by_fecha_inicio_on, -> on { where("fecha_inicio::date = ?", Date.parse(on)) }
  scope :by_fecha_fin_on, -> on{ where("fecha_fin::date = ?", Date.parse(on)) }
  scope :by_fecha_fin_before, -> before { where("fecha_fin::date < ?", Date.parse(before)) }
  scope :by_fecha_fin_after, -> after { where("fecha_fin::date > ?", Date.parse(after)) }

	scope :by_all_attributes, -> value { joins(:deposito).
	where("inventarios.descripcion ilike ? OR depositos.nombre ilike ? OR to_char(fecha_inicio, 'DD/MM/YYYY') ilike ? OR
		to_char(fecha_fin, 'DD/MM/YYYY') ilike ?" ,
	    "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%").references(:depositos)
	}

  def save_with_details(procesar=false)
    transaction do
      puts "Buscando parametro por empresa #{Settings.empresa} "
      parametro = ParametrosEmpresa.by_empresa_codigo(Settings.empresa).first
      puts "Parametro encontrado: #{parametro}"
      up_stock = procesar and (!control || parametro.ctrl_inventario_set_existencia)
      inventario_lotes.each do |detalle|
        if control
          lote_deposito = LoteDeposito.existencia(deposito_id, detalle.lote_id).first
          detalle.existencia_previa = lote_deposito.cantidad
        end
        #en la primera iteración se fija todo a cero y luego se va sumando, porque si hay packs hay que sumar la existencia entre
        #el producto en sí y el pack
        if up_stock
          Producto.fijar_stock(detalle.lote, deposito_id, 0)
        end
      end
      if up_stock
        inventario_lotes.each do |detalle|
          Producto.actualizar_stock!(detalle.lote_id, deposito_id, detalle.existencia)
        end
      end
      if !save
        raise ActiveRecord::Rollback
      end
    end
  end

  def update_with_details(params, detalles, procesar)
    transaction do
      puts "[UPDATE]: Actualizar los datos de la cabecera: #{params}"
      if !update_attributes(params)
        raise ActiveRecord::Rollback
      end
      up_stock = procesar and (!control || Settings.control_inventario.setear_existencia)

      inventario_lotes.each do |detalle|
        if control
          lote_deposito = LoteDeposito.existencia(deposito_id, detalle.lote_id).first
          detalle.existencia_previa = lote_deposito.cantidad
        end
        if up_stock
          puts "[INVENTARIO][UPDATE]: Fijando existencia a cero"
          Producto.fijar_stock(detalle.lote, deposito_id, 0)
        end
      end

      if up_stock
        #Actualizar la existencia: actualizar_stock
        inventario_lotes.each do |detalle|
          puts "[INVENTARIO][UPDATE]: Sumando existencia #{detalle.producto.descripcion}, #{detalle.existencia}"
          Producto.actualizar_stock!(detalle.lote_id, deposito_id, detalle.existencia)
        end
      end
    end
  end

  def destroy_with_details
    transaction do
      errors = []
      @detalles = InventarioLote.where("inventario_id = ?", id)
      @detalles.each do |det|
       det.destroy!
      end

      destroy!
    end
  end

  def correcto
    !control || inventario_lotes.select {|det| det.existencia != det.existencia_previa}.empty?
  end

  def self.minimizar_inventario()
    transaction do
      inventario = Inventario.find(5)
      inventario_id = inventario.id
      detalles = InventarioLote.find(:all)

      new_detalles = []

      #Union por productos
      puts "Unificacion de existencias por producto"
      hash = Hash.new { |k, v| k[v] = [] }
      detalles.map do |detalle|
        hash[detalle.lote_id] << detalle.existencia
      end

      puts "Borrado de los inventario_lotes anteriores"
      #Borrar detalles anteriores
      InventarioLote.destroy_all()

      inventario_lotes = []
      puts "Sumatoria de existencia por productos"
      #Sumatoria
      hash.each do |lote_id, existencias|
        #puts "\tSumando producto #{lote_id}"
        new_detalle = InventarioLote.new
        new_detalle.lote_id = lote_id
        new_detalle.inventario_id = inventario_id
        new_detalle.existencia = 0
        existencias.each { |a| new_detalle.existencia+=a }
        #puts "\tSumando producto #{lote_id} - #{new_detalle.existencia}"
        new_detalle.save
        inventario_lotes.push(new_detalle)

      end

      puts "Eliminando otros inventarios"
      inventarios = Inventario.where("id != ?", inventario_id)
      inventarios.each do |i|
        i.destroy()
      end

      puts "Clasificando productos por categoría"
      hash_categorias = Hash.new { |k, v| k[v] = [] }
      inventario_lotes.map do |ip|
        #puts "\t Producto: #{ip.producto.descripcion} - Categorias: #{ip.producto.categorias.first}"
        hash_categorias[ip.producto.categorias[0].id] << ip
      end
      puts "Ordenando categorias"
      hash_categorias.keys.sort

      puts "Creando inventarios por categoria"
      hash_categorias.each {|key, value| puts "#{key} is #{value.length}" }

      hash_categorias.each do |categoria_id, ip|
        terminado = false
        i = 1
        while !terminado
          if (ip.length > 100)
            if i==1
              init = 0
            else
              init = (i-1) * 100 + 1
            end
            offset = (init-1) + 100
            if offset > ip.length
              offset = ip.length
            end
            terminado = ip.length == offset
          else
            init = 0
            offset = ip.length
            terminado = true
          end
          puts "\tCreando inventario: #{ip[0].producto.categorias.first.nombre + " " + i.to_s}"
          new_inventario = Inventario.new(fecha_inicio: inventario.fecha_inicio, fecha_fin: inventario.fecha_fin,
            created_at: inventario.created_at, updated_at: inventario.updated_at, usuario_id: inventario.usuario_id,
            deposito_id: inventario.deposito_id, control: inventario.control, procesado: inventario.procesado,
            descripcion: ip[0].producto.categorias.first.nombre + " " +i.to_s)
          puts "\tAgregando detalles #{init} ...  #{offset}"
          new_inventario.inventario_lotes = ip[init..offset]
          puts "\tGuardando Inventario"
          new_inventario.save
          new_inventario.inventario_lotes.each do |p|
            new_detalle = InventarioLote.new(lote_id: p.lote_id, inventario_id: new_inventario.id, existencia: p.existencia)
            new_detalle.save
            p.destroy
          end
          i = i+1
        end
      end
    end
  end
end
