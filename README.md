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

```ruby

  class Author < ActiveRecord::Base
    has_many :articles
  end

  class Article < ActiveRecord::Base
    belongs_to :author
  end

  Author.traits.

```

## Gemfile
```ruby
gem 'activerecord-traits', github: 'yivo/activerecord-traits'
```
