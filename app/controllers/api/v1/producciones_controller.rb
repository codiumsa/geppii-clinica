class API::V1::ProduccionesController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15

  has_scope :by_codigo
  has_scope :by_descripcion
  has_scope :by_all_attributes

    def index
      tipo = params[:tipo]
      content_type = params[:content_type]
      if content_type.eql? "pdf"
        if tipo.eql? "reporte_produccion"
          @produccion = Produccion.find(params[:produccion_id])
          render xlsx: 'produccion_set',filename: "produccion_set.xlsx"

        end
      else
        if (params[:unpaged])
            @producciones = apply_scopes(Produccion).order(:id)
            render json: @producciones, each_serializer: ProduccionSerializer, meta: {total: apply_scopes(Produccion).all.count, total_pages: 0}
        else
          @producciones = apply_scopes(Produccion).page(params[:page]).per(PER_PAGE_RECORDS)
          render json: @producciones, each_serializer: ProduccionSerializer, meta: {total: apply_scopes(Produccion).all.count, total_pages: @producciones.num_pages}
        end
      end
    end

    def show
        respond_with Produccion.find(params[:id])
    end

    def new
        respond_with Produccion.new
    end

    def create
        @produccion = Produccion.new(produccion_params)
        detalles = []
        productoPadre = Producto.find(produccion_params[:producto_id])
        puts productoPadre.to_yaml
        productoPadre.producto_detalles.each do |productoDetalleTemp|
          loteDepositos = LoteDeposito.obtener_lotes_by_deposito_producto_existente(produccion_params[:deposito_id],productoDetalleTemp.producto.id).joins(:lote).readonly(false).order("lotes.fecha_vencimiento").reverse_order
          total = productoDetalleTemp.cantidad * Integer(produccion_params[:cantidad_produccion])
          loteDepositos.each do |loteDepositoTemp|
            if(loteDepositoTemp.cantidad >= total)
              loteDepositoTemp.cantidad = loteDepositoTemp.cantidad - total
              @produccion_detalle = ProduccionDetalle.new(lote_id: loteDepositoTemp.lote.id,
                                                          producto_id: loteDepositoTemp.producto.id,
                                                          cantidad: total,
                                                          deposito_id: produccion_params[:deposito_id])
              detalles.push(@produccion_detalle)
              loteDepositoTemp.save
            else
              total = total - loteDepositoTemp.cantidad
              @produccion_detalle = ProduccionDetalle.new(lote_id: loteDepositoTemp.lote.id,
                                                          producto_id: loteDepositoTemp.producto.id,
                                                          cantidad: loteDepositoTemp.cantidad,
                                                          deposito_id: produccion_params[:deposito_id])
              detalles.push(@produccion_detalle)
              loteDepositoTemp.cantidad = 0
              loteDepositoTemp.save
            end
            if(total == 0)
              break
            end

          end
        end
        @produccion.produccion_detalles = detalles
        @produccion.save
        @loteTemp = Lote.by_producto(@produccion.producto_id).first
        if(!@loteTemp.nil?)
          Producto.actualizar_stock!(@loteTemp.id,produccion_params[:deposito_id],produccion_params[:cantidad_produccion])
        else
          @loteTemp = Lote.new(codigo_lote: "loteUnico#{@produccion.producto_id}", producto_id: produccion_params[:producto_id])
          @loteTemp.save
          Producto.actualizar_stock!(@loteTemp.id,produccion_params[:deposito_id],produccion_params[:cantidad_produccion])

        end
        respond_with @produccion, location: nil
    end

    def update
        @produccion = Produccion.find_by(id: params[:id])
        if @produccion.nil?
          render json: {message: 'Resource not found'}, :status => :not_found
        else
            @produccion.update_attributes(produccion_params)
          respond_with @produccion, location: nil
        end
    end

    def destroy
        @produccion = Produccion.find_by(id: params[:id])
        if @produccion.nil?
          render json: {message: 'Resource not found'}, :status => :not_found
        else
            deposito_id = @produccion.deposito_id
            @produccion.produccion_detalles.each do |produccionDetalle|
              puts produccionDetalle.to_yaml
              loteDepositoTemp = LoteDeposito.obtener_lotes_by_deposito_producto(deposito_id,produccionDetalle.producto_id).first
              loteDepositoTemp.cantidad = loteDepositoTemp.cantidad + produccionDetalle.cantidad
              loteDepositoTemp.save
              # ProduccionDetalle.destroy
            end
            puts 'llegaaaa'
            @loteTemp = Lote.by_producto(@produccion.producto_id).first
            Producto.actualizar_stock!(@loteTemp.id,@produccion.deposito_id,-Integer(@produccion.cantidad_produccion))
            @produccion.destroy

            respond_with @produccion
  	    end
    end

    def produccion_params
        params.require(:produccion).permit(:id,:producto_id,:deposito_id,:cantidad_produccion)
    end

end
