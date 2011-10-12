require "has_unique_slug/version"

module HasUniqueSlug
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def has_unique_slug(*args)
      
      # Setup options Hash
      options = {:generates_with => :title, :slug_column => :slug}
      options.merge! args.pop if args.last.kind_of? Hash
      
      # Standaridize implementation
      title, slug = options[:generates_with], options[:slug_column]
      
      # Add ActiveRecord Callback
      before_create do |record|
        
        # Add a slug if slug doesn't exist
        if record[slug].blank?
          record[slug] = record[title].parameterize
        end
        
        # Ensure the current slug is unique in the database, if not, make it unqiue
        i = 2
        while not record.class.where(slug => record[slug]).count.zero? 
          record[slug] = "#{record[slug]}-#{i}"
          i += 1
        end  
      end
      
      # Add instance methods to objects using has_unique_slug
      class_eval do
        include HasUniqueSlug::InstanceMethods
      end
      
      # Add class methods to objects using has_unique_slug
      instance_eval do
        def find(*args)
          if args.length == 1
            where(slug => args.first).first
          else
            where(slug => args)
          end
        end
      end
    end
    
  end
  
  module InstanceMethods

    def to_param
      slug
    end

  end
end

class ActiveRecord::Base
  include HasUniqueSlug
end