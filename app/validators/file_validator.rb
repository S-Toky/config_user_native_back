class FileValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value
      if value.respond_to? :path
        unless options[:ext].include? File.extname(value.path).delete('.').to_sym
          record.errors[attribute] <<  "it'not value (#{options[:ext].join(',')})"
        end
      else
        record.errors[attribute] << (options[:message] || "it'not value")
      end
    end
    
  end
  
  private
    
end
