require "has_unique_slug/version"

module HasUniqueSlug
  def self.included(base)
    base.extend ClassMethods
  end
  
  # Builds a slug from the subject_column unless a block is specified.
  # If a block is specified, the result of the block is returned.
  def build_slug(record, subject_column)
    if subject_column.is_a?(Proc)
      slug = subject_column.call(record)
    else
      slug = record[subject_column]
    end
    slug.try(:parameterize) || '-'
  end
  
  module ClassMethods
    
    def has_unique_slug args = {}
      
      # Setup default options
      options = { :column => :slug, :subject => :title, :scope => nil }
      options.merge! args
      slug_column, subject_column, scope_column = options[:column], options[:subject], options[:scope]
      
      # Use before_validates otherwise ActiveRecord uniqueness validations on the model will fail.  Uniqueness is already guarneteed.
      # It is not recommend to use a 'validates :slug, :uniqueness => true' validation because that will add unndeeded stress on the
      # database.
      before_validation do |record|
        
        # Create base slug 
        slug_prefix = record[slug_column].blank? ? build_slug(record, subject_column) : record[slug_column].parameterize
        
        # Ensure the current slug is unique in the database, if not, make it unqiue
        test_slug, i = slug_prefix, 1
        record_scope = record.new_record? ? record.class.scoped : record.class.where("id != ?", record.id)
        
        # Add scope to uniqueness call
        unless scope_column.nil?
          record_scope = record_scope.where("#{scope_column} = ?", record[scope_column])
        end
        
        # Test for uniqueness
        while not record_scope.where("#{slug_column} = ?", test_slug).count.zero? 
          test_slug = "#{slug_prefix}-#{(i += 1)}"
        end
        
        # Set the slug in the record
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
      
    end
    
  end
  
  module InstanceMethods
    
    # Override to param method.  Outputs the specified column (or slug by default) instead of the id
    def to_param
      self.send(self.class.slug_column)
    end

  end
end

class ActiveRecord::Base
  include HasUniqueSlug
end
