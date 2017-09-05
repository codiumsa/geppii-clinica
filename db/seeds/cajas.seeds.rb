require 'active_record/fixtures'

ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "cajas")