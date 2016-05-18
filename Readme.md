
**MAPS:** A method for lightweight software processes

### Comandos a la mano:
``` ruby
  rails new project_name    #Crear proyecto
  rails server              #Iniciar servidor en localhost:3000

  rake db:create            #Crear base de datos
  rake db:migrate           #Actualizar los modelos y migraciones
  rake db:rollback         #Resetear última migracióon
  rake db:purge            #Lose all data and start again
  rake db:seed              #Insertar datos de prueba

  #Generar un controlador con sus respectiva vista
  rails generate controller controller_name

  #Generar un modelo
  rails generate model ModelName titulo:string body:text


  bundle install #Instalar las gemas que hay en el Gemfile
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

https://www.codecademy.com/articles/standard-controller-actions

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
