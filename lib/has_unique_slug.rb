require "has_unique_slug/version"

module HasUniqueSlug
  def self.included(base)
    base.extend ClassMethods
  end
  
  # Builds a slug from the subject_column unless a block is specified.
  # If a block is specified, the result of the block is returned.
  def build_slug(record, subject_column, &block)
    ( block_given? ? yield(record) : record[subject_column] ).parameterize
  end
  
  module ClassMethods
    
    def has_unique_slug(*args, &block)
      
      options = { :scope => nil }
      options.merge! args.pop if args.last.is_a? Hash
      slug_column, subject_column = args
      slug_column ||= :slug
      subject_column ||= :title
      
      # Add ActiveRecord Callback
      before_save do |record|
        
        # Add a slug if slug doesn't exist
        slug_prefix = record[slug_column].blank? ? build_slug(record, subject_column, &block) : record[slug_column]
        
        # Ensure the current slug is unique in the database, if not, make it unqiue
        test_slug, i = slug_prefix, 1
        record_scope = record.new_record? ? record.class.scoped : record.class.where("id != ?", record.id)
        while not record_scope.where("#{slug_column} = ?", test_slug).count.zero? 
          test_slug = "#{slug_prefix}-#{(i += 1)}"
        end
        
        # Set the slug
        record[slug_column] = test_slug
      end
      
      # Add instance methods to objects using has_unique_slug
      class_eval do
        include HasUniqueSlug::InstanceMethods
      end
      
      # Add configuration mechanism
      instance_eval <<-EOV
        def slug_column
          '#{slug_column}'
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