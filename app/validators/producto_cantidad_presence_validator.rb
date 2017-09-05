class ProductoCantidadPresenceValidator < ActiveModel::EachValidator
  @@invalid_message = I18n.t :cantidad_required, scope: [:activerecord, :errors, :messages]
  def validate_each(record, attribute, value)
    if value == nil and record.pack == true
      record.errors.add attribute, (options[:message] || @@invalid_message) 
    end
  end
end
