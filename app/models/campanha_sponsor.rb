class CampanhaSponsor < ActiveRecord::Base
  belongs_to :campanha
  belongs_to :sponsor

end
