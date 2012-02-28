require 'spec_helper'

class Standard < ActiveRecord::Base
  has_unique_slug
  
  def self.table_name 
    "standard" 
  end
end

class StandardWithScope < ActiveRecord::Base
  has_unique_slug :scope => :some_scope
  
  def self.table_name 
    "standard" 
  end
end

class Custom < ActiveRecord::Base
  has_unique_slug :column => :permalink, :subject => :name
  
  def self.table_name
    "custom" 
  end
end

class Custom2 < ActiveRecord::Base
  has_unique_slug :column => :permalink, :subject => Proc.new {|record| "zcvf #{record.name} zxvf"}
  
  def self.table_name
    "custom" 
  end
end

describe HasUniqueSlug do
  
  before(:all) do
    setup_db
  end
  
  after(:all) do
    teardown_db
  end
  
  after(:each) do
    Standard.destroy_all
    Custom.destroy_all
  end
  
  it "creates a unique slug" do
    r = Standard.create! :title => "Sample Record"
    r.slug.should == "sample-record"
  end
  
  it "should add incremental column if not unique" do
    Standard.create! :title => "Sample Record"
    2.upto 5 do |i|
      r = Standard.create! :title => "Sample Record"
      r.slug.should == "sample-record-#{i}"
    end
  end
  
  it "should not increment the slug if the duplicate is itself" do
    r = Standard.create! :title => "Sample Record"
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
    r = Custom2.create! :name => "Sample Record"
    r.permalink.should == "zcvf-sample-record-zxvf"
    2.upto 5 do |i|
      r = Custom2.create! :name => "Sample Record"
      r.permalink.should == "zcvf-sample-record-zxvf-#{i}"
    end
    r = Custom2.last
    slug = r.permalink
    r.save.should be_true
    r.permalink.should == slug
  end
  
  it "should allow two slugs with the same value if scopes differ" do
    r = StandardWithScope.create! :title => "Sample Record", :some_scope => 1
    r.slug.should == "sample-record"
    
    r = StandardWithScope.create! :title => "Sample Record", :some_scope => 2
    r.slug.should == "sample-record"
  end
  
  it "should increment the slug if two records share the same scope" do
    r = StandardWithScope.create! :title => "Sample Record", :some_scope => 1
    r.slug.should == "sample-record"
    
    r = StandardWithScope.create! :title => "Sample Record", :some_scope => 1
    r.slug.should == "sample-record-2"
  end
  
end