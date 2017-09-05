class Usuario < ActiveRecord::Base
  has_secure_password
  has_many :api_keys, dependent: :destroy
  #has_many :roles_usuarios
  #has_many :sucursal_usuarios
  #has_many :sucursales, through: :sucursal_usuarios, autosave: :false
  #has_many :roles, through: :roles_usuarios, autosave: :true
    
  #accepts_nested_attributes_for :sucursales
  #accepts_nested_attributes_for :roles
  has_and_belongs_to_many :sucursales
  has_and_belongs_to_many :roles

  validates :email, email: true, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :nombre, presence: true
  validates :apellido, presence: true

  scope :username, -> username { where("username = ?", "#{username}") }
	scope :by_rol, -> rol {joins(:roles).where("roles.codigo = ?", "#{rol}" )}
  scope :by_username, -> username { where("username ilike ?", "%#{username}%") }
  scope :by_nombre, -> nombre { where("nombre ilike ?", "%#{nombre}%") }
  scope :by_apellido, -> apellido { where("apellido ilike ?", "%#{apellido}%") }
  scope :by_tiene_caja_asignada, ->  { where "caja_id  IS NULL"}
  scope :by_email, -> email { where("email ilike ?", "%#{email}%") }
  scope :by_all_attributes, -> value { 
    where("nombre ilike ? OR apellido ilike ? OR email ilike ? OR username ilike ? ", 
          "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%")
  }

  def session_api_key(sucursal_id, caja_impresion_id)
   current_session = api_keys.active.sucursal(sucursal_id).session.first_or_create(sucursal_id: sucursal_id)

   if caja_impresion_id
     current_session.update_attribute(:caja_impresion_id, caja_impresion_id)
   end
   return current_session
  end

  def nombre_completo
    if nombre
      if apellido
        return nombre + apellido
      else
        return nombre
      end
    else
      return "Sin Nombre"
    end
  end

  def getPermisos
    permisos = Array.new
    for rol in roles
      for permiso in rol.recursos
        unless permisos.include?(permiso.codigo)
          permisos.push(permiso.codigo)
        end
      end
    end
    return permisos
  end

  def isAuthorized(solicitado)
    for rol in roles
      for permiso in rol.recursos
        if permiso.codigo == solicitado
          puts "El usuario tiene el permiso solicitado " + solicitado
          return true
        end
      end
    end
    puts "NO SE TIENE EL PERMISO SOLICITADO: " + solicitado
    return false 
  end

  def permitidoEnSucursal(sucursal_id)
    for sucursal in sucursales
      puts sucursal.id
      if sucursal.id == sucursal_id
        puts "permitido en sucursal"
        return true
      end
    end
     puts "no permitido en sucursal"
    return false
  end

end
