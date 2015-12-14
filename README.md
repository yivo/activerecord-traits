# ActiveRecord Type Traits

##### This library provides a series of classes to obtain type information of ActiveRecord models, attributes and associations.
This library is focused only on standard ActiveRecord features and will not provide information for ActiveRecord plugins such as Globalize, CarrierWave, Paranoid and others.

API design is done in good and clear manner for best understanding.

**All base ActiveRecord features are supported.**

**Supported advanced ActiveRecord features:**

 1. `has_many`, `has_one`, `has_and_belongs_to_many`, `belongs_to` associations
 2. Intermediate and through (deep) associations
 3. Polymorphic associations
 4. Single Table Inheritance
 5. SQL Join metadata

## Example of usage
```ruby

  class Author < ActiveRecord::Base
    has_many :articles
    has_one :photo, as: :imageable
  end

  class Article < ActiveRecord::Base
    belongs_to :author
  end
  
  class Photo
    belongs_to :imageable, polymorphic: true
  end

  Author.traits.associations[:articles].has_many?                    # => true
  Author.traits.associations[:articles].to_class                     # => Article
  Author.traits.associations[:articles].paired_through_polymorphism? # => true
  
  Photo.traits.associations[:imageable].polymorphic?                          # => true
  Photo.traits.associations[:imageable].accepted_classes_through_polymorphism # => [Author]
  Photo.traits.attributes[:imageable_type].polymorphic_type?                  # => true
  
  Article.traits.attributes[:author_id].foreign_key?                          # => true 
  
  class Present < ActiveRecord::Base
  end
  
  class Toy < Present
  end
  
  class VideoGame < Present
  end
  
  Present.traits.sti_base? # => true
  Toy.traits.sti_derived?  # => true
  Toy.traits.sti_chain     # => [Present, Toy]
  
```

## Gemfile
```ruby
gem 'activerecord-traits', github: 'yivo/activerecord-traits'
```
