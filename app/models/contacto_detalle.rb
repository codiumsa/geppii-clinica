class ContactoDetalle < ActiveRecord::Base
  belongs_to :contacto
  belongs_to :moneda

end
