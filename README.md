# Has Unique Slug
Generates a unique slug for use as a drop-in replacement for ids Ruby on Rails Active Record

## Install

Add `gem 'has_unique_slug'` to your Gemfile and run `bundle install` to get it installed.

Tested and working on Rails 3.1.x

## Usage

Assume you have a Post model that has a title and slug column, you can use the following to uniquely parameterize title:

	class Post < ActiveRecord::Base
		has_unique_slug
	end
	

A unique slug will be generated automatically on creation by calling parameterize on title.
If the generated slug is not unique, a number is added onto the end to ensure uniqueness. The series starts at 2 and increments up by one until a unique slug is found.
If a slug is already specified, this slug will be used however the above rules still apply for incrementing the slug until a unique one is found.
Ex. Post 1 has title "Sample Post" which would then generate slug "sample-post"
    Post 2 has also has title "Sample Post" which then would generate slug "sample-post-2"

You can specify which column to use to generate the slug and which column to use to store the slug. Below is the default:

	class Post < ActiveRecord::Base
	    # the column slug will store the slug, title.parameterize will be called to build the slug
		has_unique_slug :slug, :title
	end	

The entire argument list is `has_unique_slug(slug_column, title_column, options, &block)` however there are no options you can pass in at this time.

If only 1 argument is given, use that column to store the slug:

	class Post < ActiveRecord::Base
		has_unique_slug :permalink		# Uses the permalink column to store the slug
	end

Optionally, a block can be provided to generate the slug:

    class Car < ActiveRecord::Base
        has_unique_slug {|car| "#{car.year} #{car.name}"}
    end
Note the space: parameterize will be called on the result of the block to ensure the slug is url friendly.

You do not have to modify your controller to get this to work:

    class PostsController < ApplicationController
        
        # ...
        
        def show
            @post = Post.find params[:id]
            # you may still use find_by_id to find a record by the database id if need be
        end
    end     

Then you may use all your standard url helpers as normal.
Ex. If a `post` has a title "Sample Post" and a slug "sample-post", the helper `post_path(post)` will create /posts/sample-post

## TODO:

- Would like to write some tests.
- Would like to be able to specify scope for uniqueness
- Possibly consider optimizing the method to ensure uniqueness