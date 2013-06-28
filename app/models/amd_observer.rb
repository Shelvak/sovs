# Add, Modify, Delete observer 
class AmdObserver < ActiveRecord::Observer
  observe :'ActiveRecord::Base'

  # observe only #create actions here
  def after_create(record)
    table = record.class.table_name

    keys = values = ''
    i = 0

    record.attributes.each do |key, value|
      unless i.zero?
        keys += ', '
        values += ', '
      end

      keys += key
      values += if value.is_a?(Numeric)
                 value.to_s
               else
                 "'#{value.to_s}'"
               end
      i += 1
    end

    query = "INSERT INTO #{table} (#{keys}) VALUES (#{values});"

    %x{echo "#{query}" >> #{Rails.root}/cont-bk}
    
    true
  end
end
