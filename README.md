<p align="center">
  <img src="https://i.imgur.com/mZI1ECO.png" alt="Deep Cloning Logo" width="200" height="200"/>
</p>

# Deep Cloning

#### Replicate Ruby on Rails Database Hierarchies with Precision

Welcome to **Deep Cloning**, a powerful Ruby on Rails gem designed to replicate your database hierarchies seamlessly. Whether you're dealing with complex data structures or intricate relationships between models, Deep Cloning ensures that every aspect of your database is accurately reproduced, maintaining model attributes and associations.


## Table of Contents

- [Introduction](#introduction)
- [Key Features](#key-features)
- [How to Use](#how-to-use)
- [Benefits for Large Companies](#benefits-for-large-companies)
- [Get Started](#get-started)
- [Contact](#contact)


## Introduction

Modern applications often require the ability to create copies of database hierarchies while preserving the integrity of the data. Deep Cloning provides a robust solution for Ruby on Rails applications, allowing you to trigger precise replication of database records starting from a specified model, all the way down its associations.


## Key Features

- **Model Attributes Preservation**: Deep Cloning retains all values for database columns (model attributes), ensuring data fidelity throughout the replication process.
  
- **Association Cloning**: Replicate complex hierarchies effortlessly, preserving relationships between models, just like the original.

- **Customizable Cloning**: Tailor the cloning process to meet your specific needs with customizable options and configurations.

- **Efficiency and Performance**: Deep Cloning is optimized for speed and efficiency, making it suitable for both small-scale projects and enterprise-level applications.


## How to Use

1. **Installation**: Add the Deep Cloning gem to your Rails project by including it in your Gemfile and running `bundle install`.

```ruby
gem 'deep-cloning'
```

2. **Trigger Cloning**: To replicate a model and its associations, simply call the `DeepCloning::Clone.new(@root_item, opts).replicate` method on the desired model instance root item.

```rb
# @root_item should be already created and is the item to be copied
# @target_item should be already created and is the item which will receive the @root_item hierarchy children to be copied

DeepCloning::Clone.new(@root_item, opts).replicate do |source, destiny, moment|
  case moment
  when :before_save
    before_save(source, destiny)
  when :after_save
    after_save(source, destiny)
  when :skip?
    skip?(source)
  else
    destiny
  end
end

# Clone options
def opts
  {
    # Which classes do you want to copy on the hierarchy?
    including: %w[Project User City],

    # This is necessary: the id of the @root_item should point to the @target_item.
    'RootClass' => { @root_item.id => @target_item },

    # Do you want to save the root model instance?
    save_root: false
  }
end

# You can set up specific handling on the source/destiny item beforing replicating the item
def before_save(source, destiny)
  case source
  when SpecificModel
    # Do specific handlings
  end
end

# You can set up specific handling on the source/destiny item after replicating the item
def after_save(source, destiny)
  case source
  when SpecificModel
    # Do specific handlings
  end
end

# Do you want to skip the copy of an item based on a criteria?
def skip?(source)
  return true if source.is_a? User and source.age > 50
  false
end
```

3. **Enjoy Precision Replication**: Your new project and its associated records are now accurately cloned, ready for use.


## Benefits for Large Companies

- **Streamlined Data Management**: Deep Cloning simplifies the process of replicating complex database hierarchies, saving valuable time and resources for large-scale projects.

- **Data Privacy and Security**: Replicate data within your secure environment, minimizing the need for external tools or services.

- **Efficient Testing and Development**: Expedite development and testing processes by creating comprehensive test datasets and prototypes with ease.

- **Enhanced Productivity**: Maximize efficiency by rapidly setting up new projects with data structures mirroring existing successful ones.


## Get Started

Explore the potential of Deep Cloning by incorporating it into your Ruby on Rails projects. Clone with precision, maintain data integrity, and elevate your development workflow. Check out the official documentation and get started today!

For any inquiries or collaboration opportunities, feel free to reach out to the repository creators.


## Contact

1. [Nilton Vasques](https://www.linkedin.com/in/nilton-vasques-carvalho-junior-65b89835)
2. [Victor Cordeiro Costa](https://www.linkedin.com/in/victor-costa-0bba7197/)

---

*This repository is maintained and developed by [Victor Cordeiro Costa](https://www.linkedin.com/in/victor-costa-0bba7197/) and [Nilton Vasques](https://www.linkedin.com/in/nilton-vasques-carvalho-junior-65b89835). For inquiries, partnerships, or support, please contact us.
