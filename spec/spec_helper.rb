require 'rubygems'
require 'bundler/setup'
gem 'activerecord'
require 'active_record'
gem 'sqlite3'
require 'sqlite3'

require 'has_unique_slug' # and any other gems you need

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :standard_setup do |t|
      t.column :title, :string
      t.column :slug, :string
    end
    create_table :customized_setup do |t|
      t.column :name, :string
      t.column :permalink, :string
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |t|
    ActiveRecord::Base.connection.drop_table t
  end
end

RSpec.configure do |config|
  
end