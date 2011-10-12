require "has_unique_slug/version"

module HasUniqueSlug
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def has_unique_slug(title_col = "title", slug_col = "slug")
      
      # Add ActiveRecord Callback
      before_create do |record|
        
        # Add a slug if slug doesn't exist
        if record[slug_col].blank?
          record[slug_col] = record[title_col].parameterize
        end
        
        # Ensure the current slug is unique in the database, if not, make it unqiue
        i = 2
        while not record.class.where("#{slug_col} = ?", record[slug_col]).count.zero? 
          record[slug_col] = "#{record[slug_col]}-#{i}"
          i += 1
        end  
      end
      
      # Add instance methods to objects using has_unique_slug
      class_eval do
        include HasUniqueSlug::InstanceMethods
      end
      
      # Add configuration mechanism
      instance_eval <<-EOV
        def slug_column
          '#{slug_col}'
        end
        
        def title_column
          '#{title_col}'
        end
      EOV
      
      # Add find method to override ActiveRecord::Base.find
      instance_eval do
        def find(*args)
          if args.length == 1
            where("#{slug_column} = ?", args.first).first
          else
            where("#{slug_column} IN (?)", args)
          end
        end
      end
    end
    
  end
  
  module InstanceMethods

    def to_param
      self.send(self.class.slug_column)
    end

  end
end

class ActiveRecord::Base
  include HasUniqueSlug
end