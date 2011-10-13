# HasUniqueSlug
Generates a unique slug for use as a drop-in replacement for ids Ruby on Rails Active Record

## Install

Add `gem has_unique_slug` to your Gemfile and run `bundle install` to get it installed.

## Usage

Assume you have a Post model that has a title and slug column, you can use the following to uniquely parameterize title:

	class Post < ActiveRecord::Base
		has_unique_slug
	end
	

A unique slug will be generated automatically on creation.  
If the generated slug is not unique, a number is added onto the end to endure uniqueness. The series starts at 2 and increments
up by one until a unique slug is found.
If a slug is already specified, this slug will be used however the above rules still apply for uniqueness.

You can specify which column to use to generate the slug and which column to use to store the slug. Below is the default:

	class Post < ActiveRecord::Base
		has_unique_slug :slug, :title
	end	

Or if only 1 argument is given, use that column to store the slug:

	class Post < ActiveRecord::Base
		has_unique_slug :permalink		# Uses the permalink column to store the slug
	end

Optionally, a block can be provided to generate the slug:

    class Car < ActiveRecord::Base
        has_unique_slug {|car| "#{car.year} #{car.name}"}
    end
Note the space: parameterize will be called on the result of the block to ensure the slug is url friendly.

## TODO:

- Would like to write some tests.
- Would like to be able to specify scope for uniqueness
- Possibly consider optimizing the method to ensure uniqueness