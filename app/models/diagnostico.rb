class Diagnostico
  attr_accessor :tipo, :nombre, :tiene_observacion, :tiene_localizacion, :si_no, :tiene_lados, :lados

  def initialize( tipo, nombre, tiene_observacion, tiene_localizacion, si_no, tiene_lados, lados)
    @tipo = tipo
    @nombre = nombre
    @tiene_observacion = tiene_observacion ? tiene_observacion : false
    @tiene_localizacion = tiene_localizacion ? tiene_localizacion : false
    @si_no = si_no ? si_no : false
    @tiene_lados = tiene_lados ? tiene_lados : false
    @lados = lados.nil? ? nil : lados.to_hash.values
  end

  def self.getDiagnosticosByTipo(tipo)
    diagnosticos = Settings.diagnosticos.select { |d| d.tipo.eql?(tipo)}
    puts diagnosticos
    diagnosticos.map { |opt| Diagnostico.new(opt.tipo, opt.nombre, opt.tiene_observacion, opt.tiene_localizacion, opt.si_no, opt.tiene_lado, opt.lados)}
  end

  def self.getDiagnosticos()
    Settings.diagnosticos.map { |opt| Diagnostico.new(opt.tipo, opt.nombre, opt.tiene_observacion, opt.tiene_localizacion, opt.si_no, opt.tiene_lado, opt.lados)}
  end

  def self.getTratamientosByTipo(tipo)
    tratamientos = Settings.tratamientos.select { |d| d.tipo.eql?(tipo)}
    tratamientos.map { |opt| Diagnostico.new(opt.tipo, opt.nombre, opt.tiene_observacion, opt.tiene_localizacion, opt.si_no, opt.tiene_lado, opt.lados)}
  end

  def self.getTratamientos()
    Settings.tratamientos.map { |opt| Diagnostico.new(opt.tipo, opt.nombre, opt.tiene_observacion, opt.tiene_localizacion, opt.si_no, opt.tiene_lado, opt.lados)}
  end

  def self.getTiposDiagnostico()
    hash = {}
    Settings.diagnosticos.map { |opt| opt.tipo}.uniq
  end

  def self.getTiposTratamiento()
    Settings.tratamientos.map { |opt| opt.tipo}.uniq
  end
end
