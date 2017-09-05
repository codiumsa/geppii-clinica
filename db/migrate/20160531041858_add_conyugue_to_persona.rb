class AddConyugueToPersona < ActiveRecord::Migration
  def change
    add_reference :personas, :conyugue, index: true
  end
end
