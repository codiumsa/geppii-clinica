require 'active_record/fixtures'

ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "empresas")
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "sucursales")
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "tipo_creditos")
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures/" + Settings.empresa, "sucursales_vendedores")

