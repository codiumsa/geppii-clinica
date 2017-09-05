class APIKey < ActiveRecord::Base
  validates :scope, inclusion: { in: %w( session api ) }
  before_create :generate_access_token, :set_expiry_date
  belongs_to :usuario
  belongs_to :sucursal
  belongs_to :caja_impresion

  scope :session, -> { where(scope: 'session') }
  scope :api,  -> { where(scope: 'api') }
  scope :active,  ->  { where('expired_at >= ?', Time.now) }
  scope :sucursal,  -> sucursal { where('sucursal_id = ?', sucursal) }
  scope :caja_impresion,  -> caja_impresion { where('caja_impresion_id = ?', caja_impresion) }
  scope :user, -> user { where('usuario_id = ?', user)}
    

  private

  def set_expiry_date
      gabino = false;
      empresas = Empresa.all();
      empresas.map do |empresa|
          if(empresa.codigo == 'nancy' || empresa.codigo == 'librada')
              gabino = true;
          end
      end
      if(!gabino)
        self.expired_at = if self.scope == 'session'
                            4.days.from_now
                            #4.hours.from_now
                          else
                            30.days.from_now
                          end
      else
          self.expired_at = if self.scope == 'session'
                             4.days.from_now
                                #4.hours.from_now
                              else
                                30.days.from_now
                              end
      end
  end

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end
end