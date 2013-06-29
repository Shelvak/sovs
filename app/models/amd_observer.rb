# Add, Modify, Delete observer 
class AmdObserver < ActiveRecord::Observer
  observe :'ActiveRecord::Base'

  # observe only #create actions here
  def after_create(record)
    table = table_name(record)

    keys = values = ''
    i = 0

    record.attributes.each do |key, value|
      unless i.zero?
        keys += ', '
        values += ', '
      end

      p key
      p value

      keys += key
      values += if value.is_a?(Numeric) 
                  value.to_s
                else 
                  "'#{value.to_s.gsub("'",'\"')}'"
                end
      i = 1
    end

    query = "INSERT INTO #{table} (#{keys}) VALUES (#{values});"

    %x{echo "#{query}" >> #{Rails.root}/cont-bk}
    true
  end

  def after_update(record)
    attrs = {}
    set = ''
    i = 0

    record.changes.each do |key, values| 
      new = values.last
      set += ', ' unless i.zero?
      set += " \"#{key}\" = "
      set += (new.is_a?(Numeric) ? new.to_s : "'#{new.to_s}'")
      i = 1
    end

    table = table_name(record)
    identifier = "#{table}.id = #{record.id}"

    query = "UPDATE \"#{table}\" SET #{set} WHERE #{identifier};"

    %x{echo "#{query}" >> #{Rails.root}/cont-bk}
    true
  end

  private

  def table_name(record)
    record.class.table_name
  end
end
