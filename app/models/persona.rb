# encoding: utf-8
# == Schema Information
#
# Table name: personas
#
#  id                   :integer          not null, primary key
#  tipo_persona         :string(255)
#  ci_ruc               :string(255)
#  razon_social         :string(255)
#  direccion            :string(255)
#  barrio               :string(255)
#  ciudad_id            :integer
#  telefono             :string(255)
#  celular              :string(255)
#  estado_civil         :string(255)
#  fecha_nacimiento     :date
#  correo               :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  sexo                 :string(255)
#  numero_hijos         :integer
#  estudios_realizados  :string(255)
#  tipo_domicilio       :string(255)
#  antiguedad_domicilio :float
#  nacionalidad         :string(255)
#  conyugue_id          :integer
#  nombre               :string(255)
#  apellido             :string(255)
#

class Persona < ActiveRecord::Base
  belongs_to :ciudad
  belongs_to :cargo
  belongs_to :conyugue, autosave: true
  has_many :ventas, dependent: :destroy
  has_many :sponsors, dependent: :destroy

  validates :tipo_persona, presence: true
  validates :razon_social, presence: true
  validates :ci_ruc, uniqueness: true
  # validates_presence_of :fecha_nacimiento, :message => "Ingrese una fecha de nacimiento"

  scope :by_razon_social, -> razon_social { where("razon_social ilike ?", "#{razon_social}") }
  scope :by_ciRuc, -> value { where("ci_ruc ilike ?", "#{value}") }


  accepts_nested_attributes_for :conyugue

  def self.create (persona_param)
    conyugue_param = persona_param[:conyugue]

    if persona_param[:tipo_persona] == "Física"
      nombre = persona_param[:nombre]
      apellido = persona_param[:apellido]
      if nombre.nil?
        nombre = ""
      end
      if apellido.nil?
        apellido = ""
      end
      razon_social = nombre + " " + apellido
    elsif persona_param[:tipo_persona] == "Jurídica"
      nombre = nil
      apellido = nil
      razon_social = persona_param[:razon_social]
    end

    return Persona.new(tipo_persona: persona_param[:tipo_persona],
                       ci_ruc: persona_param[:ci_ruc],
                       razon_social: persona_param[:razon_social],
                       nombre: persona_param[:nombre],
                       apellido: persona_param[:apellido],
                       direccion: persona_param[:direccion],
                       edad: persona_param[:edad],
                       barrio: persona_param[:barrio],
                       ciudad_id: persona_param[:ciudad_id],
                       telefono: persona_param[:telefono],
                       celular: persona_param[:celular],
                       sexo: persona_param[:sexo],
                       nacionalidad: persona_param[:nacionalidad],
                       estado_civil: persona_param[:estado_civil],
                       fecha_nacimiento: persona_param[:fecha_nacimiento],
                       correo: persona_param[:correo])
  end

  def self.update(id_persona, pparams)
    puts "ACTUALIZANDO PERSONA: #{id_persona}"
    puts pparams.to_yaml
    @persona = Persona.find_by(id: id_persona)
    @conyugue_param = pparams[:conyugue]
    puts @persona.to_yaml

    if not @conyugue_param.nil?
      if not @persona.conyugue_id.nil?
        @conyugue = Conyugue.find_by(id: @persona.conyugue_id)
        puts @conyugue_param.to_yaml
        @conyugue.update_attribute(:nombre, @conyugue_param[:nombre])
        @conyugue.update_attribute(:apellido, @conyugue_param[:apellido])
        @conyugue.update_attribute(:nacionalidad, @conyugue_param[:nacionalidad])
        @conyugue.update_attribute(:cedula, @conyugue_param[:cedula])
        @conyugue.update_attribute(:fecha_nacimiento, @conyugue_param[:fecha_nacimiento])
        @conyugue.update_attribute(:lugar_nacimiento, @conyugue_param[:lugar_nacimiento])
        @conyugue.update_attribute(:empleador, @conyugue_param[:empleador])
        @conyugue.update_attribute(:actividad_empleador, @conyugue_param[:actividad_empleador])
        @conyugue.update_attribute(:cargo, @conyugue_param[:cargo])
        @conyugue.update_attribute(:profesion, @conyugue_param[:profesion])
        @conyugue.update_attribute(:ingreso_mensual, @conyugue_param[:ingreso_mensual])
        @conyugue.update_attribute(:concepto_otros_ingresos, @conyugue_param[:concepto_otros_ingresos])
        @conyugue.update_attribute(:otros_ingresos, @conyugue_param[:otros_ingresos])
        !@conyugue.save
      else
        @conyugue = Conyugue.new(
          nombre: @conyugue_param[:nombre],
          apellido: @conyugue_param[:apellido],
          nacionalidad: @conyugue_param[:nacionalidad],
          cedula: @conyugue_param[:cedula],
          fecha_nacimiento: @conyugue_param[:fecha_nacimiento],
          lugar_nacimiento: @conyugue_param[:lugar_nacimiento],
          empleador: @conyugue_param[:empleador],
          actividad_empleador: @conyugue_param[:actividad_empleador],
          cargo: @conyugue_param[:cargo],
          profesion: @conyugue_param[:profesion],
          ingreso_mensual: @conyugue_param[:ingreso_mensual],
          concepto_otros_ingresos: @conyugue_param[:concepto_otros_ingresos],
        otros_ingresos: @conyugue_param[:otros_ingresos])
        !@conyugue.save
      end
    end

    Persona.transaction do

      @persona.update_attribute(:tipo_persona, pparams[:tipo_persona])
      @persona.update_attribute(:ci_ruc, pparams[:ci_ruc])
      @persona.update_attribute(:razon_social, pparams[:razon_social])
      @persona.update_attribute(:direccion, pparams[:direccion])
      @persona.update_attribute(:barrio, pparams[:barrio])
      @persona.update_attribute(:telefono, pparams[:telefono])
      @persona.update_attribute(:celular, pparams[:celular])
      @persona.update_attribute(:estado_civil, pparams[:estado_civil])
      @persona.update_attribute(:fecha_nacimiento, pparams[:fecha_nacimiento])
      @persona.update_attribute(:correo, pparams[:correo])
      @persona.update_attribute(:sexo, pparams[:sexo])
      @persona.update_attribute(:numero_hijos, pparams[:numero_hijos])
      @persona.update_attribute(:estudios_realizados, pparams[:estudios_realizados])
      @persona.update_attribute(:tipo_domicilio, pparams[:tipo_domicilio])
      @persona.update_attribute(:antiguedad_domicilio, pparams[:antiguedad_domicilio])
      @persona.update_attribute(:tipo_persona, pparams[:tipo_persona])
      @persona.update_attribute(:nacionalidad, pparams[:nacionalidad])
      @persona.update_attribute(:nombre, pparams[:nombre])
      @persona.update_attribute(:apellido, pparams[:apellido])
      @persona.update_attribute(:ciudad_id, pparams[:ciudad_id])
      if not @conyugue.nil? and not @conyugue.id.nil?
        @persona.update_attribute(:conyugue_id, @conyugue.id)
      end
    end
    begin
      @persona.save!
    rescue ActiveRecord::RecordInvalid => invalid
      puts "ERROR: INVALID"
      puts @persona.errors.full_messages
    end
    return @persona
  end

end
