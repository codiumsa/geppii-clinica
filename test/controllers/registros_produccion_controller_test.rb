require 'test_helper'

class RegistrosProduccionControllerTest < ActionController::TestCase
	test "should get index" do
	    get :index
	    assert_response :success
	    assert_not_nil assigns(:registros_produccion)
	    puts(@response)
  	end
end
