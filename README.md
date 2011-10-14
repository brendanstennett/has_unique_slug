# Has Unique Slug
Generates a unique slug for use as a drop-in replacement for ids Ruby on Rails Active Record

## Install

Add `gem 'has_unique_slug'` to your Gemfile and run `bundle install` to get it installed.

Tested and working on Rails 3.1.x

## Usage

	class Post < ActiveRecord::Base
		has_unique_slug
	end

- by default, the column `title` is assumed as the identifier, and `slug` is used to store the unique slug
- `title.paramterize` is called to generate the slug unless a slug has already been assigned, in which case parameterize is called on the provided slug
- if a slug is not unique in the database, a suffix is appended on the end in the format "-n" where n starts at 2 and progresses ad infinitum until a unique slug is found.

You can specify which column to use to generate the slug and which column to use to store the slug. For example:

	class Post < ActiveRecord::Base
		has_unique_slug :column => :permalink, :subject => :name
		# will store the unique slug in the column `permalink` created from `name`
	end	

Optionally, a Proc can be used instead of a column name to create the slug:

    class Car < ActiveRecord::Base
        has_unique_slug :subject => Proc.new {|car| "#{car.year}-#{car.name}"}
    end
You do not have to call parameterize on name, this will be done automatically.  (You don't even need to add dash, a space will work fine)


You do not have to modify your controller to find records:

    class PostsController < ApplicationController
        
        # ...
        
        def show
            @post = Post.find params[:id]
            # you may still use find_by_id to find a record by the database id if need be
        end
    end     

All the standard url helper methods will still work since `to_param`  is overridden to output the slug
    
    # Ex.
    post = Post.create! :title => "Sample Post"
    post_path(post)     # /posts/sample-post

## TODO:

- Add support for scopes
- Add support for database versioning
- Consider optimizing the method to ensure a unique slug