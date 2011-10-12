# HasUniqueSlug
Generates a unique slug for use as a drop-in replacement for ids Ruby on Rails Active Record

## Install

Add `gem has_unique_slug` to your Gemfile and run `bundle install` to get it installed.

## Usage

Assume you have a Post model that has a title and slug column in which the slug column is generated from the post title.

	class Post < ActiveRecord::Base
		has_unique_slug
	end
	

A unique slug will be generated automatically on creation.  
If the generated slug is not unique, "-n" is appended onto the end. n starts at 2 and will increment by 1 until a unique slug is found.
If a slug is provided, one will not be generated, however the same rule applies as the above if the slug is not unique.

You can specify which column to use to generate the slug and which column to use to store the slug. Below is the default:

	class Post < ActiveRecord::Base
		has_unique_slug :title, :slug
	end
	

Or if only 1 argument is given, use that column to generate the slug

	class Post < ActiveRecord::Base
		has_unique_slug :name		# Uses the name column to generate the slug
	end
	

## TODO:

Would like to write some tests.