require 'spec_helper'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :standards do |t|
      t.column :title, :string
      t.column :slug, :string
    end
    
    create_table :customs do |t|
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

class Standard < ActiveRecord::Base
  has_unique_slug
  
  def self.table_name 
    "standards" 
  end
end

class Custom < ActiveRecord::Base
  has_unique_slug :permalink, :name
  
  def self.table_name
    "customs" 
  end
end

class Custom2 < ActiveRecord::Base
  has_unique_slug {|record| "zcvf #{record.title} zxvf"}
  
  def self.table_name
    "standards" 
  end
end

describe HasUniqueSlug do
  
  before(:all) do
    setup_db
  end
  
  after(:all) do
    teardown_db
  end
  
  it "creates a unique slug" do
    r = Standard.create! :title => "Sample Record"
    r.slug.should == "sample-record"
  end
  
  it "should add incremental column if not unique" do
    2.upto 5 do |i|
      r = Standard.create! :title => "Sample Record"
      r.slug.should == "sample-record-#{i}"
    end
  end
  
  it "should not increment the slug if the duplicate is itself" do
    r = Standard.last
    slug = r.slug
    r.save.should be_true
    r.slug.should == slug
  end
  
  it "should update slugs for non-standard implementation" do
    r = Custom.create! :name => "Sample Record"
    r.permalink.should == "sample-record"
    2.upto 5 do |i|
      r = Custom.create! :name => "Sample Record"
      r.permalink.should == "sample-record-#{i}"
    end
    r = Custom.last
    slug = r.permalink
    r.save.should be_true
    r.permalink.should == slug
  end
  
  it "should update slugs based on the block if a block is provided" do
    r = Custom2.create! :title => "Sample Record"
    r.slug.should == "zcvf-sample-record-zxvf"
    2.upto 5 do |i|
      r = Custom2.create! :title => "Sample Record"
      r.slug.should == "zcvf-sample-record-zxvf-#{i}"
    end
    r = Custom2.last
    slug = r.slug
    r.save.should be_true
    r.slug.should == slug
  end
  
end