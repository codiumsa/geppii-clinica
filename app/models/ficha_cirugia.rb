class FichaCirugia < ActiveRecord::Base
   belongs_to :paciente
   belongs_to :colaborador
   belongs_to :campanha

   scope :paciente_id, -> value{ where("paciente_id = ?", "#{value}" ).order(created_at: :desc).limit(1)}
   scope :paciente_id_fichas, -> value{ where("paciente_id = ?", "#{value}" ).order('estado DESC,id')}

end
