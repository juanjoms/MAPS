
## MAPS: A method for lightweight software processes

### Dependences

| Software | Version                               |
| -------- | --------------------------------------|
| Ruby     | 2.2.3                                 |
| Rails    | 4.2.5                                 |
| Gems     | See versions in the [Gemfile](Gemfile)|

### Installation
[How to install Ruby on Rails with rbenv on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-14-04)


* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


### Useful commands:
``` ruby
  rails new project_name    #Create a project
  rails server              #Start the server in localhost:3000

  rake db:create          #Create database
  rake db:migrate         #Update models and migrations
  rake db:rollback        #Reset the last migration
  rake db:purge           #Lose all data and start again
  rake db:seed            #Insert seed data
  rake db:setup           #Runs db:create, db:schema:load, db:seed

  #Generate a controller with its view
  rails generate controller controller_name

  #Generate a model
  rails generate model ModelName titulo:string body:text

  #Install the gems listed in the Gemfile
  bundle install
```

``` ruby
rails generate model Company
rails generate devise:install
rails generate devise User
rails generate devise:views

rails generate model ProcessArea
rails generate model SpecificGoal
rails generate model Practice
rails generate model UserPractice
rails g ratyrate user
rails generate model ScrumPractice


```
[Standard controller actions](https://www.codecademy.com/articles/standard-controller-actions)

