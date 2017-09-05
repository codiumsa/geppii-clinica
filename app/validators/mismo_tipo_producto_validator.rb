class MismoTipoProductoValidator < ActiveModel::EachValidator
  @@invalid_message = I18n.t :mismo_tipo_producto, scope: [:activerecord, :errors, :messages]
  def validate_each(record, attribute, value)
    if value != nil and record.id == value.id then
      record.errors.add attribute, (options[:message] || @@invalid_message) 
    end
  end
end
