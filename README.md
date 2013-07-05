# Has Unique Slug
[![Build Status](https://secure.travis-ci.org/HuffMoody/has_unique_slug.png)](http://travis-ci.org/HuffMoody/has_unique_slug)

Generates a unique slug for use as a drop-in replacement for ids Ruby on Rails Active Record.  It allows for easy search
engine friendly URLs.

http://example.com/articles/1

Becomes

http://example.com/articles/my-article

## Install

Add `gem 'has_unique_slug'` to your Gemfile and run `bundle install` to get it installed.

Tested and working on Rails 3.1.x

## Usage

	class Post < ActiveRecord::Base
		has_unique_slug
	end

- by default, the column `title` is assumed as the identifier, and `slug` is used to store the unique slug
- `title.paramterize` is called to generate the slug unless a slug has already been manually assigned, in which case #parameterize is called on the provided slug to ensure it is url friendly
- if a slug is not unique in the database, a suffix is appended on the end in the format "-n" where n starts at 2 and progresses ad infinitum until a unique slug is found.

## Options

You can specify which column to use to generate the slug and which column to use to store the slug. For example:

	class Post < ActiveRecord::Base
		has_unique_slug :column => :permalink, :subject => :name
		# will store the unique slug in the column `permalink` created from `name`
	end	

Optionally, a Proc can be used instead of a column name to create the slug:

    class Car < ActiveRecord::Base
        has_unique_slug :subject => Proc.new {|car| "#{car.year} #{car.name}"}
    end
Note: You do not have to call parameterize on the output of the proc, this will be done automatically.

### Usage with scopes

Scopes are supported when generating the slug column where each slug will be unique for a given scope.  To use with scopes, 
simply specify the option on setup

    class Article < ActiveRecord::Base
        has_unique_slug scope: :category_id
    end

### Finders

Use rails' built-in conventions for finding by an attribute.

Note: you will have to modify this if your slug column is set to something else.

    class PostsController < ApplicationController
        
        # ...
        
        def show
            @post = Post.find_by_slug(params[:id])
        end
    end     

All the standard url helper methods will still work since `to_param`  is overridden to output the slug
    
    # Ex.
    post = Post.create! :title => "Sample Post"
    post_path(post)     # /posts/sample-post


## Gotchas

If you are adding this to an existing project that already contains records, perform the necessary setup then run something like `Post.all.each {|p| p.save }` in the rails console to populate the slug columns.

## Active Admin

Due to the way inherited resources work (a dependancy of activeadmin), this gem will not work with Active Admin out of the box.  You can easily get around this however by adding the following line to your resource's admin file:

    # articles.rb
    
    ActiveAdmin.register Article do
        controller do
          defaults :finder => :find_by_slug
        end
        
        # ..
    end

## TODO:

- Add support for database versioning
- Consider optimizing the method to ensure a unique slug
- Add rake task for rebuildings slugs

## License

Copyright (c) 2012 Brendan Stennett

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
