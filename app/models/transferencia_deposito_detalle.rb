class TransferenciaDepositoDetalle < ActiveRecord::Base
  belongs_to :transferencia, :class_name => 'TransferenciaDeposito'
  belongs_to :lote, :class_name => 'Lote'
end
