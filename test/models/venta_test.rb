require 'test_helper'

class VentaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
    test "deberia imprimir venta en impresora existente" do
        caja_imp = CajaImpresion.find(185092427) #Caja de Impresión uno
        venta = Venta.last
        venta.uso_interno = true 
        imp = Impresora.where("tipo_documento=? AND caja_impresion_id=?", 'interno', caja_imp.id).first
        assert_not_nil imp "debe existir una caja de impresión para tickets internos"
        
        
end
