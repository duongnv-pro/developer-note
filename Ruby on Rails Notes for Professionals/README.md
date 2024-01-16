# Ruby on Rails Notes for Professionals

![](https://i.imgur.com/waxVImv.png)

### [View all DevNotes](../README.md)

![](https://i.imgur.com/waxVImv.png)

#### Chapter 2: Routing

To see only the routes that map to a particular controller

```bash
rails routes -c static_pages
```

##### Section 2.2: Constraints

```ruby
# lib/api_version_constraint.rb
class ApiVersionConstraint
  def initialize(version:, default:)
    @version = version
    @default = default
  end

  def version_header
    "application/vnd.my-app.v#{@version}"
  end

  def matches?(request)
    @default || request.headers["Accept"].include?(version_header)
  end
end

# config/routes.rb
require "api_version_constraint"

Rails.application.routes.draw do
  namespace :v1, constraints: ApiVersionConstraint.new(version: 1, default: true) do
    resources :users # Will route to app/controllers/v1/users_controller.rb
  end

  namespace :v2, constraints: ApiVersionConstraint.new(version: 2) do
    resources :users # Will route to app/controllers/v2/users_controller.rb
  end
end
```

##### Section 2.3: Scoping route

###### Scope by URL:

```yml
scope 'admin' do
  get 'dashboard', to: 'administration#dashboard'
  resources 'employees'
end
```

This generates the following routes

```
get         '/admin/dashboard',           to: 'administration#dashboard'
post        '/admin/employees',           to: 'employees#create'
get         '/admin/employees/new',       to: 'employees#new'
get         '/admin/employees/:id/edit',  to: 'employees#edit'
get         '/admin/employees/:id',       to: 'employees#show'
patch/put   '/admin/employees/:id',       to: 'employees#update'
delete      '/admin/employees/:id',       to: 'employees#destroy
```

###### Scope by module

`module` looks for the controller files under the subfolder of the given name

```yml
scope module: :admin do
  get 'dashboard', to: 'administration/dashboard'
end

# => get '/dashboard', to: 'admin/administration#dashboard
```

You can rename the path helpers prefix by adding an as parameter

```yml
# 1
scope 'admin', as: :administration do
  get 'dashboard'
end
# => administration_dashboard_path

# 2
namespace :admin do
end

scope 'admin', module: :admin, as: :admin
```

##### Scope by controller

```yml
scope controller: :management do
  get 'dashboard'
  get 'performance'
end

# => get '/dashboard', to: 'management#dashboard'
# => get '/performance', to: 'management#performance
```

###### Shallow Nesting

```yml
resources :auctions do
shallow do
resources :bids do
resources :comments
end
end
end
```

##### Section 2.6: Split routes into multiple files

```yml
# config/routes.rb:
YourAppName::Application.routes.draw do
  require_relative 'routes/admin_routes'
  require_relative 'routes/sidekiq_routes'
  require_relative 'routes/api_routes'
  require_relative 'routes/your_app_routes'
end

# config/routes/api_routes.rb
YourAppName::Application.routes.draw do
  namespace :api do
  # ...
  end
end
```

##### Section 2.8: Member and Collection Routes

Defining a member block inside a resource creates a route that can act on an individual member of that resource-based route:

```ruby
resources :posts do
  member do
    get 'preview'
  end
  collection do
    get 'search'
  end
end

# => 'posts/:id/preview', to: 'posts#preview'
# => /posts/search', to: 'posts#search'
```

An alternate syntax:

```ruby
resources :posts do
  get 'preview', on: :member
  get 'search', on: :collection
end
```

#### Section 2.9: Mount another applicatio

mount is used to mount another application (basically rack application) or rails engines to be used within thecurrent application

```ruby
mount SomeRackApp, at: "some_route", as: :myapp
```

#### Section 2.12: Redirects and Wildcard Routes

If you want to provide a URL out of convenience for your user but map it directly to another one you're alreadyusing. Use a redirect:

```ruby
# config/routes.rb
TestApp::Application.routes.draw do
  get 'courses/:course_name' => redirect('/courses/%{course_name}/lessons'), :as => "course"
end
```

#### Section 2.13: Scope available locales

If your application is available in different languages, you usually show the current locale in the URL.

```ruby
scope '/(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
  root 'example#root'# other routes
end
```

#### Section 3.5: Creating A Migration

Create a migration by running:

```ruby
rails generate migration AddTitleToCategories title:string

rails generate migration RemoveTitleFromCategories title:string

rails g CreateUsers name bio
```

Precedence

```ruby
- (Add|Remove)<ignored>(To|From)<table_name>
- <ignored>JoinTable<ignored>
- Create<table_name
```

#### Section 4.4: Replace HTML code in Views

```ruby
<div>
  <%= yield :header %>
</div>

<% content_for :header do %>
  <ul>
    <li>Line Item 1</li>
    <li>Line Item 2</li>
  </ul>
<% end %>
```

### Chapter 5: ActiveRecord Migrations

#### Section 5.1: Adding multiple columns to a table

```ruby
rails generate migration NAME [field[:type][:index] field[:type][:index]] [options]

# For example
rails generate migration AddDetailsToUsers name:string salary:decimal email:string

rails g migration change_column_in_table
```

#### Section 5.2: Add a reference column to a table

```ruby
rails generate migration AddTeamRefToUsers team:references

rails generate migration AddTeamRefToUsers team:references:index
```

#### Section 5.4: Add a new column with an index

```ruby
rails generate migration AddEmailToUsers email:string:index
```

#### Section 5.5: Run specific migration

```
rails db:migrate:up VERSION=20090408054555
```

#### Section 5.6: Redo migrations

You can rollback and then migrate again using the redo command. This is basically a shortcut that combinesrollback and migrate tasks.

```ruby
rails db:migrate:redo

rails db:migrate:redo STEP=3
```

#### Section 5.8: Remove an existing column from a table

```ruby
rails generate migration RemoveNameFromUsers name:string
```

#### Section 5.10: Running migrations in dierent environments

```ruby
rails db:migrate RAILS_ENV=test
```

#### Section 5.11: Create a new table

```ruby
rails generate migration CreateUsers name:string salary:decimal
```

#### Section 5.22: Forbid null values

To forbid null values in your table columns, add the :null parameter to your migration

### Chapter 6: Rails Best Practices

#### Section 6.1: Fat Model, Skinny Controller

“Fat Model, Skinny Controller” refers to how the M and C parts of MVC ideally work together. Namely, any non-response-related logic should go in the model, ideally in a nice, testable method. Meanwhile, the “skinny” controlleris simply a nice interface between the view and model.

In practice, this can require a range of different types of refactoring, but it all comes down to one idea: by movingany logic that isn’t about the response to the model (instead of the controller), not only have you promoted reusewhere possible but you’ve also made it possible to test your code outside of the context of a request

```ruby
def index
  @published_posts = Post.where('published_at <= ?', Time.now)
  @unpublished_posts = Post.where('published_at IS NULL OR published_at > ?', Time.now)
end

# You can change it to this:
def index
  @published_posts = Post.published
  @unpublished_posts = Post.unpublished
end
# move the logic to your post model
scope :published, ->(timestamp = Time.now) { where('published_at <= ?', timestamp) }
scope :unpublished, ->(timestamp = Time.now) { where('published_at IS NULL OR published_at > ?',timestamp) }
```

Fat Model, Skinny Controller

```text
- Dễ duy trì: Model chứa hầu hết logic nghiệp vụ, giúp dễ dàng duy trì và mở rộng.
- Tính tái sử dụng: Các phần logic xử lý dữ liệu có thể được tái sử dụng một cách dễ dàng vì chúng nằm trong Model.
- Rõ ràng hóa trách nhiệm: Phân chia rõ ràng trách nhiệm giữa Model và Controller, giúp mã nguồn trở nên dễ đọc và hiểu hơn
```

#### Section 6.2: Domain Objects (No More Fat Models)

Don't write this logic in the model

```ruby
# app/models/order.rb
class Order < ActiveRecord::Base
  SERVICE_COMMISSION = 0.15
  STRIPE_PERCENTAGE_COMMISSION = 0.029
  STRIPE_FIXED_COMMISSION = 0.30
  ...
  def commission
    amount*SERVICE_COMMISSION - stripe_commission
  end

  private

  def stripe_commission
    amount*STRIPE_PERCENTAGE_COMMISSION + STRIPE_FIXED_COMMISSION
  end
end
```

Prefer domain objects, with the calculation of the commission completely abstracted from the responsibility ofpersisting orders:

```ruby
# app/models/order.rb
class Order < ActiveRecord::Base
  ...
  # No reference to commission calculation
end

# lib/commission.rb
class Commission
  SERVICE_COMMISSION = 0.15

  def self.calculate(payment_method, model)
    model.amount*SERVICE_COMMISSION - payment_commission(payment_method, model)
  end

  private

  def self.payment_commission(payment_method, model)
    # There are better ways to implement a static registry,
    # this is only for illustration purposes.
    Object.const_get("#{payment_method}Commission").calculate(model)
  end
end

# lib/stripe_commission.rb
class StripeCommission
  STRIPE_PERCENTAGE_COMMISSION = 0.029
  STRIPE_FIXED_COMMISSION = 0.30

  def self.calculate(model)
    model.amount*STRIPE_PERCENTAGE_COMMISSION+ STRIPE_PERCENTAGE_COMMISSION
  end
end

# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  def create
    @order = Order.new(order_params)
    @order.commission = Commission.calculate("Stripe", @order)
    ...
  end
end
```

Using domain objects has the following architectural advantages:

- it's extremely easy to unit test, as no fixtures or factories are required to instantiate the objects with the logic.
- works with everything that accepts the message amount.
- keeps each domain object small, with clearly defined responsibilities, and with higher cohesion.
- easily scales with new payment methods by addition, not modification.
- stops the tendency to have an ever-growing User object in each Ruby on Rails application.

personally like to put domain objects in lib. If you do so, remember to add it to autoload_paths:

```ruby
# config/application.rb
config.autoload_paths << Rails.root.join('lib')
```

You may also prefer to create domain objects more action-oriented, following the `Command/Query pattern`.

- Command/Query pattern
- Repository pattern/Query Objects

#### Section 6.5: Don't Repeat Yourself (DRY)

Also Fat Model, Skinny Controller is DRY, because you write the code in your model and in the controller only do thecall

```ruby
# Post model
scope :unpublished, ->(timestamp = Time.now) { where('published_at IS NULL OR published_at > ?',timestamp) }

# Any controller
def index
  ....
  @unpublished_posts = Post.unpublished
  ....
end

def others
  ...
  @unpublished_posts = Post.unpublished
  ...
end
```

#### Section 6.6: You Ain’t Gonna Need it (YAGNI)

If you can say “YAGNI” (You ain’t gonna need it) about a feature, you better not implement it. There can be a lot ofdevelopment time saved through focussing onto simplicity.
Solutions:

- KISS - Keep it simple, stupid
- YAGNI – You Ain’t Gonna Need it
- Continuous Refactoring

### Chapter 10: User Authentication in Rails

#### Section 10.1: Authentication using Devise

```ruby
gem 'devise'

$ rails generate devise:instal

config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

#### Section 10.2: Devise Controller Filters & Helpers

To set up a controller with user authentication using devise, add this before_action: (assuming your devise model is'User'):

```ruby
before_action :authenticate_user!

# To vefiry if a user is signed in
user_signed_in?
# For the current signed-in user, use this helper:
current_user
# You can access the session for this scope:
user_session
```

#### Section 10.4: has_secure_password

Add `has_secure_password` module to User model
Now you can create a new user with password

```ruby
user = User.new email: 'bob@bob.com', password: 'Password1', password_confirmation: 'Password1'

user.authenticate('somepassword')
```

#### Section 10.5: has_secure_token

```ruby
# Schema: User(token:string, auth_token:string)
class User < ActiveRecord::Base
  has_secure_token
  has_secure_token :auth_tokenend
end
```

Now when you create a new user a token and auth_token are automatically generated

```ruby
user.token # => "pX27zsMN2ViQKta1bGfLmVJE"
user.auth_token # => "77TMHrHJFvFDwodq8w7Ev2m7"

user.regenerate_token # => true
user.regenerate_auth_token # => true
```

### Chapter 11: ActiveRecord Associations

#### Section 11.1: Polymorphic association

This type of association allows an ActiveRecord model to belong to more than one kind of model record. Commonexample:

```ruby
class Human < ActiveRecord::Base
  has_one :address, :as => :addressable
end

class Company < ActiveRecord::Base
  has_one :address, :as => :addressable
end

class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
end

# Here is what it would look like:
class Address < ActiveRecord::Base
  belongs_to :human
  belongs_to :company
end
```

#### Section 11.2: Self-Referential Association

Self-referential association is used to associate a model with itself. The most frequent example would be, tomanage association between a friend and his follower

```ruby
$ rails g model friendship user_id:references friend_id:integer

class User < ActiveRecord::Base
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :userend
end
class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
end
```

#### Section 11.6: The has_many :through association

A has_many :through association is often used to set up a many-to-many connection with another model. Thisassociation indicates that the declaring model can be matched with zero or more instances of another model byproceeding through a third model.

For example, consider a medical practice where patients make appointments to see physicians. The relevantassociation declarations could look like this:

```ruby
class Physician < ApplicationRecord
  has_many :appointments
  has_many :patients, through: :appointments
end
class Appointment < ApplicationRecord
  belongs_to :physician
  belongs_to :patient
end
class Patient < ApplicationRecord
  has_many :appointments
  has_many :physicians, through: :appointments
end
```

#### Section 11.7: The has_one :through association

A has_one :through association sets up a one-to-one connection with another model. This association indicatesthat the declaring model can be matched with one instance of another model by proceeding through a third model.

For example, if each supplier has one account, and each account is associated with one account history, then thesupplier model could look like this:

```ruby
class Supplier < ApplicationRecord
  has_one :account
  has_one :account_history, through: :account
end
class Account < ApplicationRecord
  belongs_to :supplier
  has_one :account_history
end
class AccountHistory < ApplicationRecord
  belongs_to :account
end
```

### Chapter 12: ActiveRecord Validations

#### Section 12.1: Validating length of an attribute

#### Section 12.2: Validates format of an attribute

#### Section 12.3: Validating presence of an attribute

### Section 12.4: Custom validations

You can add your own validations adding new classes inheriting from ActiveModel::Validator or fromActiveModel::EachValidator

ActiveModel::Validator and validates_with

```ruby
# app/validators/starts_with_a_validator.rb
class StartsWithAValidator < ActiveModel::Validator
  def validate(record)
    unless record.name.starts_with? 'A'
      record.errors[:name] << 'Need a name starting with A please!'
    end
  end
end

class Person < ApplicationRecord
  validates_with StartsWithAValidator
end
```

ActiveModel::EachValidator and validate

```ruby
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || 'is not an email')
    end
  end
end

class Person < ApplicationRecord
  validates :email, presence: true, email: true
end
```

#### Section 12.5: Validates inclusion of an attribute

```ruby
class Country < ApplicationRecord
  validates :continent, inclusion: { in: %w(Africa Antartica Asia AustraliaEurope North America South America) }
end
```

#### Section 12.6: Grouping validation

```ruby
class User < ApplicationRecord
  with_options if: :is_admin? do |admin|
    admin.validates :password, length: { minimum: 10 }
    admin.validates :email, presence: true
  end
end
```

#### Section 12.7: Validating numericality of an attribute

```ruby
class Player < ApplicationRecord
  validates :points, numericality: true
  validates :games_played, numericality: { only_integer: true }
end
```

#### Section 12.8: Validate uniqueness of an attribute

#### Section 12.9: Skipping Validations

#### Section 12.10: Confirmation of attribute

You should use this when you have two text fields that should receive exactly the same content. For example, youmay want to confirm an email address or a password. This validation creates a virtual attribute whose name is thename of the field that has to be confirmed with \_confirmation appended

#### Section 12.11: Using :on option

The :on option lets you specify when the validation should happen. The default behavior for all the built-invalidation helpers is to be run on save (both when you're creating a new record and when you're updating it).

```ruby
class Person < ApplicationRecord
  # it will be possible to update email with a duplicated value
  validates :email, uniqueness: true, on: :create

  # it will be possible to create the record with a non-numerical age
  validates :age, numericality: true, on: :update

  # the default (validates on both create and update)
  validates :name, presence: true
end
```

#### Section 12.12: Conditional validation

Sometimes you may need to validate record only under certain conditions.

```ruby
class User < ApplicationRecord
  validates :name, presence: true, if: :admin?

  def admin?
    # conditional here that returns boolean value
  end
end

class User < ApplicationRecord
  validates :first_name, presence: true, if: Proc.new { |user| user.last_name.blank? }
  validates :first_name, presence: true, unless: Proc.new { |user| user.last_name.present? }
  validates :first_name, presence: true, if: 'last_name.blank?'
end
```

### Chapter 13: ActiveRecord Query Interface

#### Section 13.1: .where

#### Section 13.2: .where with an array

#### Section 13.3: Scopes

#### Section 13.4: Get first and last record

#### Section 13.5: Ordering

#### Section 13.6: where.not

#### Section 13.7: Includes

ActiveRecord with includes ensures that all of the specified associations are loaded using the minimum possiblenumber of queries. So when querying a table for data with an associated table, both tables are loaded intomemory.

```ruby
@authors = Author.includes(:books).where(books: { bestseller: true } )

# this will print results without additional db hitting
@authors.each do |author|
  author.books.each do |book|
    puts book.title
  end
end
```

#### Section 13.8: Joins

#### Section 13.9: Limit and Offset

#### Section 13.10: .find_by

#### Section 13.11: .delete_all

#### Section 13.13: .group and .count

#### Section 13.14: .distinct (or .uniq)

### Chapter 16: Configuration

Create a YAML file in the config/ directory, for example: config/neo4j.ym
The content of neo4j.yml can be something like the below (for simplicity, default is used for all environments):

```ruby
# config/neo4j.yml
default: &default
  host: localhost
  port: 7474
  username: neo4j
  password: root

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default

# config/application.rb
module MyApp
  class Application < Rails::Application
    config.neo4j = config_for(:neo4j)
  end
end

# => Rails.configuration.neo4j['host']
# => localhost
```

### Chapter 17: I18n - Internationalization

```ruby
# Example config/locales/en.yml
en:
  page:
    users: "%{users_count} users currently online"
# In models, controller, etc...
I18n.t('page.users', users_count: 12)

# Shortcut in views - DRY!
# Use only the dot notation
# Important: Consider you have the following controller and view page#users

# ERB Example app/views/page/users.html.erb
<%= t('.users', users_count: 12) %>
```

#### Section 17.2: Translating ActiveRecord model attributes

`globalize` gem is a great solution to add translations to your ActiveRecord models. You can install it adding this toyour Gemfile

#### Section 17.3: Get locale from HTTP request

Sometimes it can be useful to set your application locale based upon the request IP. You can easily achieve thisusing `Geocoder`. Among the many things Geocoder does, it can also tell the location of a request

#### Section 17.4: Pluralization

```ruby
# config/locales/en.yml
en:
  online_users:
    one: "1 user is online"
    other: "%{count} users are online"

I18n.t("online_users", count: 1)
#=> "1 user is online"

I18n.t("online_users", count: 4)
#=> "4 users are online"
```

#### Section 17.5: Set locale through requests

```ruby
class ApplicationController < ActionController::Base
  before_action :set_locale

  protected

  def set_locale
    # Remove inappropriate/unnecessary ones
    I18n.locale = params[:locale] ||                              # Request parameter
      session[:locale] ||                                         # Current session
      (current_user.preferred_locale if user_signed_in?) ||       # Model saved
      configurationextract_locale_from_accept_language_header ||  # Language header - browser config
      I18n.default_locale                                         # Set in your config files, english by super-default
  end

  # Extract language from request header
  def extract_locale_from_accept_language_header
    if request.env['HTTP_ACCEPT_LANGUAGE']
      lg = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first.to_sym
      lg.in?([:en, YOUR_AVAILABLE_LANGUAGES]) ? lg : nil
    end
  end
end

# config/routes.rb
scope "(:locale)", locale: /en|fr/ do
  resources :products
end
```

The locale param could come from an URL like this

```
http://yourapplication.com/products?locale=en
http://yourapplication.com/en/products
```

Session-based or persistence-based

```ruby
class SetLanguageController < ApplicationController
  skip_before_filter :authenticate_user!
  after_action :set_preferred_locale

  # Generic version to handle a large list of languages
  def change_locale
    I18n.locale = sanitize_language_param
    set_session_and_redirect
  end

  def fr
    I18n.locale = :fr
    set_session_and_redirect
  end

  def en
    I18n.locale = :en
    set_session_and_redirect
  end

  private

  def set_session_and_redirect
    session[:locale] = I18n.locale
    redirect_to :back
  end
  def set_preferred_locale
    if user_signed_in?
      current_user.preferred_locale = I18n.locale.to_s
      current_user.save if current_user.changed?
    end
  end
end
```

### Chapter 18: Using GoogleMaps with Rails

### Chapter 19: File Uploads

Start using File Uploads in Rails is quite simple, first thing you have to do is to choice plugin for managing uploads.The most common onces are Carrierwave and Paperclip

### Chapter 20: Caching

### Chapter 21: ActionController

#### Section 21.1: Basic REST Controlle

#### Section 21.4: Rescuing ActiveRecord::RecordNotFound withredirect_to

You can rescue a RecordNotFound exception with a redirect instead of showing an error page:

```ruby
class ApplicationController < ActionController::Base

  # your other stuff

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_path, 404, alert: I18n.t("errors.record_not_found")
  end
end
```

#### Section 21.5: Display error pages for exceptions

If you want to display to your users meaningful errors instead of simple "sorry, something went wrong", Rails has anice utility for the purpose

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end
```

We can now add a rescue_from to recover from specific errors:

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    render html: "Record <strong>not found</strong>", status: 404
  end
end
```

OR use gem `Gaffe`

#### Section 21.6: Output JSON instead of HTML

```ruby
class UsersController < ApplicationController
  def index
    hashmap_or_array = [{ name: "foo", email: "foo@example.org" }]

    respond_to do |format|
      format.html { render html: "Hello World" }
      format.json { render json: hashmap_or_array }
    end
  end
end
```

This will respond in two different ways to requests on /users:

- If you visit /users or /users.html, it will show an html page with the content Hello World
- If you visit /users.json, it will display a JSON object containing

#### Section 21.9: Filtering parameters (Basic)

```ruby
class UsersController < ApplicationController
  private

  def user_params
    if params[:name] == "john"
      params.permit(:name, :sentence)
    else
      params.permit(:name)
    end
  end
end
```

#### Section 21.10: Redirecting

You can go back to the previous page the user visited using:

```ruby
redirect_to :back
# Note that in Rails 5 the syntax for redirecting back is different:
redirect_back fallback_location: "http://stackoverflow.com/"
```

Which will try to redirect to the previous page and in case not possible (the browser is blocking the HTTP_REFERRERheader), it will redirect to `:fallback_location`

#### Section 21.11: Using Views

```ruby
class UsersController < ApplicationController
  def index
    @name = "john"

    respond_to do |format|
      format.html
      # format.html { render "pages/home" }
    end
  end
end
```

The view app/users/index.html.erb will be rendered. If the view is:

```ruby
Hello <strong><%= @name %></strong>
```

### Chapter 23: Safe Constantize

#### Section 23.1: Successful safe_constantize

User is an ActiveRecord or Mongoid class. Replace User with any Rails class in your project (even something likeInteger or Array)

```ruby
my_string = "User" # Capitalized string
  # => 'User'
my_constant = my_string.safe_constantize
  # => User
my_constant.all.count
  # => 18

my_string = "Array"
  # => 'Array'
my_constant = my_string.safe_constantize
  # => Array
my_constant.new(4)
  # => [nil, nil, nil, nil]
```

### Chapter 24: Rails 5

#### Section 24.2: Creating a Ruby on Rails 5 API

```ruby
rails new app_name --api

cd app_name
bundle install
# You should also start your database.
rake db:setup
rails server
```

### Chapter 25: Authorization with CanCan

#### Section 25.1: Getting started with CanCan

Permissions are defined in the Ability class and can be used from controllers, views, helpers, or any other place inthe code.

```ruby
gem "cancancan"
```

Then define the ability class:

```ruby
# app/models/ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)
  end
end
```

Then check authorization using load_and_authorize_resource to load authorized models into the controller:

```ruby
class ArticlesController < ApplicationController
  load_and_authorize_resource

  def show
  # @article is already loaded and authorized
  end
end
```

`authorize!` to check authorization or raise an exception

```ruby
def show
  @article = Article.find(params[:id])
  authorize! :read, @article
end
```

`can?` to check if an object is authorized against a particular action anywhere in the controllers, views, or helpers

```ruby
<% if can? :update, @article %>
  <%= link_to "Edit", edit_article_path(@article) %>
<% end %>
```

#### Section 25.2: Handling large number of abilities

Once the number of abilities definitions start to grow in number, it becomes more and more difficult to handle the Ability file.
The first strategy to handle these issue is to move abilities into meaningful methods, as per this example:

```ruby
class Ability
  include CanCan::Ability

  def initialize(user)
    anyone_abilities

    if user
      if user.admin?
        admin_abilities
      else
        authenticated_abilities
      end
    else
      guest_abilities
    end
  end

  private

  def anyone_abilities
    # define abilities for everyone, both logged users and visitors
  end

  def guest_abilities
    # define abilities for visitors only
  end

  def authenticated_abilities
    # define abilities for logged users only
  end

  def admin_abilities
    # define abilities for admins only
  end
end
```

Once this class grow large enough, you can try breaking it into different classes to handle the different responsibilities like this:

```ruby
# app/models/ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)
    self.merge Abilities::Everyone.new(user)

    if user
      if user.admin?
        self.merge Abilities::Admin.new(user)
      else
        self.merge Abilities::Authenticated.new(user)
      end
    else
      self.merge Abilities::Guest.new(user)
    end
  end
end
```

and then define those classes as:

```ruby
# app/models/abilities/guest.rb
module Abilities
  class Guest
    include CanCan::Ability

    def initialize(user)
      # Abilities for anonymous visitors only
    end
  end
end
```

and so on with `Abilities::Authenticated`, `Abilities::Admin` or any other else.

#### Section 25.3: Defining abilities

Abilities are defined in the `Ability class` using can and cannot methods. Consider the following commented example for basic reference:

```ruby
class Ability
  include CanCan::Ability

  def initialize(user)
    # for any visitor or user
    can :read, Article

    if user
      if user.admin?
        # admins can do any action on any model or action
        can :manage, :all
      else
        # regular users can read all content
        can :read, :all
        # and edit, update and destroy their own user only
        can [:edit, :destroy], User, id: user_id
        # but cannot read hidden articles
        cannot :read, Article, hidden: true
      end
    else
      # only unlogged visitors can visit a sign_up page:
      can :read, :sign_up
    end
  end
end
```

#### Section 25.4: Quickly test an ability

If you'd like to quickly test if an ability class is giving the correct permissions, you can initialize an ability in theconsole or on another context with the rails environment loaded, just pass an user instance to test against:

```ruby
test_ability = Ability.new(User.first)
test_ability.can?(:show, Post) #=> true
other_ability = Ability.new(RestrictedUser.first)
other_ability.cannot?(:show, Post) #=> true
```

### Chapter 26: Mongoid

### Chapter 27: Gems

#### Section 27.1: Gemfiles

### Chapter 28: Change default timezone

#### Section 28.1: Change Rails timezone AND have Active Recordstore times in this timezone

```ruby
# application.rb
config.time_zone = 'Eastern Time (US & Canada)'
config.active_record.default_timezone = :local
```

#### Section 28.2: Change Rails timezone, but continue to haveActive Record save in the database in UTC

```ruby
# application.rb
config.time_zone = 'Eastern Time (US & Canada)
```

### Chapter 30: Upgrading Rails

To upgrade from Rails 4.2 to Rails 5.0, you must be using Ruby 2.2.2 or newer. After upgrading your Ruby version ifrequired, go to your Gemfile and change the line:

```ruby
gem 'rails', '~> 5.0.0'
```

and on the command line run:

```ruby
bundle update
rake rails:update
```

### Chapter 31: ActiveRecord Locking

#### Section 31.1: Optimistic Locking

```ruby
user_one = User.find(1)
user_two = User.find(1)

user_one.name = "John"
user_one.save
# Run at the same instance
user_two.name = "Doe"
user_two.save # Raises a ActiveRecord::StaleObjectError
```

#### Section 31.2: Pessimistic Locking

```ruby
appointment = Appointment.find(5)
appointment.lock!
#no other users can read this appointment,
#they have to wait until the lock is released
appointment.save!
#lock is released, other users can read this account
```

### Chapter 32: Debugging

#### Section 32.1: Debugging Rails Application

Two popular gems for debugging are `debugger` (for ruby 1.9.2 and 1.9.3) and `byebug` (for ruby >= 2.x).

1. Add debugger or byebug to the development group of Gemfile
2. Run bundle install
3. Add debugger or byebug as the breakpoint
4. Run the code or make request
5. See the rails server log stopped at the specified breakpoint
6. At this point you can use your server terminal just like rails console and check the values of variable and params
7. For moving to next instruction, type next and press enter
8. For stepping out type c and press enter

If you want to debug .html.erb files, break point will be added as `<% debugger %>`

#### Section 32.2: Debugging Ruby on Rails Quickly + Beginneradvice

#### Section 32.3: Debugging ruby-on-rails application with pry

**Setup**

```ruby
group :development, :test do
  gem 'pry'
end
```

**Use**
Using pry in your application is just including `binding.pry` on the breakpoints you want to inspect while debugging.You can add `binding.pry` breakpoints anywhere in your application that is interpreted by ruby interpreter (anyapp/controllers, app/models, app/views files)

#### Section 32.4: Debugging in your IDE

### Chapter 33: Configure Angular with Rails

#### Section 33.1: Angular with Rails 101

Step 1: Create a new Rails app
Step 2: Remove Turbolinks

- Removing turbolinks requires removing it from the Gemfile.
  - `gem 'turbolinks`
- Remove the require from app/assets/javascripts/application.js
  - `//= require turbolinks`

Step 3: Add AngularJS to the asset pipeline

```ruby
gem 'angular-rails-templates'
gem 'bower-rails'

# bundle install
```

Add bower so that we can install the AngularJS dependency:

```ruby
rails g bower_rails:initialize json
```

Add Angular to bower.json:

```json
{
  "name": "bower-rails generated dependencies",

  "dependencies": {
    "angular": "latest",
    "angular-resource": "latest",
    "bourbon": "latest",
    "angular-bootstrap": "latest",
    "angular-ui-router": "latest"
  }
}
```

Now that bower.json is setup with the right dependencies, let’s install them:

```ruby
bundle exec rake bower:install
```

Step 4: Organize the Angular app
Create the following folder structure in app/assets/javascript/angular-app/:

```ruby
templates/
modules/
filters/
directives/
models/
services/
controllers/
```

In `app/assets/javascripts/application.js`, add **require** for Angular, the template helper, and the Angular app file structure. Like this:

```js
//= require jquery
//= require jquery_ujs

//= require angular
//= require angular-rails-templates
//= require angular-app/app

//= require_tree ./angular-app/templates
//= require_tree ./angular-app/modules
//= require_tree ./angular-app/filters
//= require_tree ./angular-app/directives
//= require_tree ./angular-app/models
//= require_tree ./angular-app/services
//= require_tree ./angular-app/controllers
```

Step 5: Bootstrap the Angular app
Create app/assets/javascripts/angular-app/app.js.coffee:

```coffee
@app = angular.module('app', [ 'templates' ])

@app.config([ '$httpProvider', ($httpProvider)->
$httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrftoken]').attr('content')
]) @app.run(-> console.log 'angular app running' )
```

Create an Angular module at app/assets/javascripts/angular-app/modules/example.js.coffee.erb:

```coffee
@exampleApp = angular.module('app.exampleApp', [ # additional dependencies here ]) .run(
  ->console.log 'exampleApp running' )
```

Create an Angular controller for this app at app/assets/javascripts/angular-app/controllers/exampleCtrl.js.coffee:

```coffee
angular.module('app.exampleApp').controller("ExampleCtrl", [ '$scope', ($scope)->
console.log 'ExampleCtrl running' $scope.exampleValue = "Hello angular and rails" ]
```

Now add a route to Rails to pass control over to Angular. Inconfig/routes.rb:

```ruby
Rails.application.routes.draw do get 'example' => 'example#index' end
```

Generate the Rails controller to respond to that route:

```ruby
rails g controller Example
```

In app/controllers/example_controller.rb:

```ruby
class ExampleController < ApplicationController
  def index
  end
end
```

In the view, we need to specify which Angular app and which Angular controller will drive this page. So inapp/views/example/index.html.erb:

```html
<div
  ng-app="app.exampleApp"
  ng-controller="ExampleCtrl"
>
  <p>Value from ExampleCtrl:</p>
  <p>{{ exampleValue }}</p>
</div>
```

### Chapter 34: Rails logger

#### Section 34.1: Rails.logger

Always use `Rails.logger.{debug|info|warn|error|fatal}` rather than puts. This allows your logs to fit into thestandard log format, have a timestamp and have a level so you choose whether they are important enough to beshown in a specific environment

You can easily rotating rails production logs with LogRotate.You just have to do small configuration as below
Open /etc/logrotate.conf with your favourite linux editor vim or nano and add the below code in this file atbottom.

```ruby
/YOUR/RAILSAPP/PATH/log/*.log {
  daily
  missingok
  rotate 7
  compress
  delaycompress
  notifempty
  copytruncate
}
```

So, How It Works This is fantastically easy. Each bit of the configuration does the following

- daily – Rotate the log files each day. You can also use weekly or monthly here instead.
- missingok – If the log file doesn’t exist,ignore it
- rotate 7 – Only keep 7 days of logs around
- compress – GZip the log file on rotation
- delaycompress – Rotate the file one day, then compress it the next day so we can be sure that it won’tinterfere with the Rails server
- notifempty – Don’t rotate the file if the logs are empty
- copytruncate – Copy the log file and then empties it. This makes sure that the log file Rails is writing to always exists so you won’t get problems because the file does not actually change. If you don’t use this, youwould need to restart your Rails application each time

**Running Logrotate**
Since we just wrote this configuration, you want to test it.
To run logrotate manually, just do: `sudo /usr/sbin/logrotate -f /etc/logrotate.conf`

### Chapter 35: Prawn PDF

### Chapter 36: Rails API

#### Section 36.1: Creating an API-only application

```bash
rails new my_api --api
```

### Chapter 37: Deploying a Rails app on Heroku

### Chapter 38: ActiveSupport

#### Section 38.1: Core Extensions: String Access

- at
- from
- to
- first
- last

#### Section 38.2: Core Extensions: String to Date/Time Conversion

- to_time
- to_date
- to_datetime

#### Section 38.3: Core Extensions: String Exclusion

- include?
- exclude?

#### Section 38.4: Core Extensions: String Filters

- squish
- remove
- truncate
- truncate_words
- strip_heredoc

```ruby
%{ Multi-line
             string }.squish # => "Multi-line string"
"  foo bar \n \t boo".squish # => "foo bar boo"

str = "foo bar test"
str.remove(" test") # => "foo bar"
str.remove(" test", /bar/) # => "foo

'Once upon a time in a world far far away'.truncate(27)
# => "Once upon a time in a wo...
'Once upon a time in a world far far away'.truncate_words(4)
# => "Once upon a time..."

'Once<br>upon<br>a<br>time<br>in<br>a<br>world'.truncate_words(5, separator: '<br>')
# => "Once<br>upon<br>a<br>time<br>in..."

'And they found that many people were sleeping better.'.truncate_words(5, omission: '... (continued)')
# => "And they found that many... (continued)"
```

#### Section 38.5: Core Extensions: String Inflection

pluralize - Returns of plural form of the string.
singularize - Returns the singular form of the string.

```ruby
'post'.pluralize             # => "posts"
'posts'.singularize              # => "post"
'the blue mailmen'.singularize   # => "the blue mailman"
```

- constantize
- safe_constantize

```ruby
'Module'.constantize # => Module
'blargle'.constantize # => NameError: wrong constant name blargle
'blargle'.safe_constantize # => nil
```

- camelize: Converts strings to UpperCamelCase
- titleize: Capitalizes all the words and replaces some characters in the string to create a nicer looking title.
- underscore: Makes an underscored, lowercase form from the expression in the string.
- dasherize: Replaces underscores with dashes in the string.

```ruby
'active_record'.camelize              # => "ActiveRecord"
'active_record'.camelize(:lower)      # => "activeRecord"
'man from the boondocks'.titleize     # => "Man From The Boondocks"
'ActiveModel'.underscore              # => "active_model"
'puni_puni'.dasherize                 # => "puni-puni"
```

- demodulize
- deconstantize

```ruby
'ActiveRecord::CoreExtensions::String::Inflections'.demodulize # => "Inflections"
'::Net::HTTP'.deconstantize # => "::Net"
'String'.deconstantize      # => ""
```

- parameterize
- tableize
- classify
- humanize
- upcase_first
- foreign_key

```ruby
"Donald E. Knuth".parameterize              # => "donald-e-knuth"
'RawScaledScorer'.tableize                  # => "raw_scaled_scorers"
'ham_and_eggs'.classify                     # => "HamAndEgg"
'employee_salary'.humanize                  # => "Employee salary"
'what a Lovely Day'.upcase_first            # => "What a Lovely Day"
'Message'.foreign_key                       # => "message_id
```

### Chapter 39: Form Helpers

####Section 39.1: Creating a search form

#### Section 39.2: Dropdown

```ruby
@models = Model.all
select_tag "models", options_from_collection_for_select(@models, "id", "name"), {}
```

#### Section 39.3: Helpers for form elements

- Checkboxes
- Radio Buttons
- Text Area
- Number Field
- Password Field
- Email Field
- Telephone Field
- Date Helpers

```ruby
<%= check_box_tag(:pet_dog) %>
<%= label_tag(:pet_dog, "I own a dog") %>

<%= radio_button_tag(:age, "child") %>
<%= label_tag(:age_child, "I am younger than 18") %>

<%= text_area_tag(:message, "This is a longer text field", size: "25x6") %>

<%= number_field :product, :rating %>
<%= password_field_tag(:password) %>
<%= email_field(:user, :email) %>
<%= telephone_field :user, :phone %>

<%= date_field(:user, :reservation) %> # input[type="date"]
<%= week_field(:user, :reservation) %> # input[type="week"]
<%= time_field(:user, :check_in) %> # input[type="time"]
```

### Chapter 40: ActiveRecord Transactions

### Section 40.2: Different ActiveRecord classes in a single transaction

Though the transaction class method is called on some ActiveRecord class, the objects within the transaction blockneed not all be instances of that class. This is because transactions are per-database connection, not per-model.

```ruby
Account.transaction do
  balance.save!
  account.save!
end

# The transaction method is also available as a model instance method
balance.transaction do
  balance.save!
  account.save!
end
```

#### Section 40.4: `save` and `destroy` are automatically wrapped ina transaction

Consequence changes to the database are not seen outside your connection until the operation is complete.

For example, if you try to update the index of a search engine in `after_save` the indexer won't see the updated record. The `after_commit` callback is the only one that is triggered once the update is committed.

#### Section 40.5: Callbacks

- after_rollback

#### Section 40.6: Rolling back a transaction

`ActiveRecord::Base.transaction` uses the `ActiveRecord::Rollback` exception to distinguish a deliberate rollback from other exceptional situations.

```ruby
class BooksController < ActionController::Base
  def create
    Book.transaction do
      book = Book.new(params[:book])
      book.save!
      if today_is_friday?
        # The system must fail on Friday so that our support department
        # won't be out of job. We silently rollback this transaction
        # without telling the user.
        raise ActiveRecord::Rollback, "Call tech support!"
      end
    end
    # ActiveRecord::Rollback is the only exception that won't be passed on
    # by ActiveRecord::Base.transaction, so this line will still be reached
    # even on Friday.
    redirect_to root_url
  end
end
```

### Chapter 41: RSpec and Ruby on Rails

#### Section 41.1: Installing RSpec

Add rspec-rails to both the `:development` and `:test` groups in the Gemfile:

```ruby
group :development, :test do
  gem 'rspec-rails', '~> 3.5'
end
```

Initialize it with:

```bash
rails generate rspec:install
```

This will create a `spec/` folder for your tests, along with the following configuration files:

- `.rspec` contains default options for the command-line rspec tool
- `spec/spec_helper.rb` includes basic RSpec configuration options
- `spec/rails_helper.rb` adds further configuration options that are more specific to use RSpec and Rails together.

### Chapter 42: Decorator pattern

#### Section 42.1: Decorating a Model using Draper

```ruby
# app/decorators/user_decorator.rb
class UserDecorator < Draper::Decorator
  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def created_at
    Time.use_zone(h.current_user.timezone) do
      object.created_at.strftime("%A, %d %b %Y %l:%M %p")
    end
  end
end
```

Given a @user variable containing an ActiveRecord object, you can access your decorator by calling `#decorate` onthe @user, or by specifying the Draper class if you want to be specific.

```
<% user = @user.decorate %><!-- OR -->
<% user = UserDecorator.decorate(@user) %>
<h1><%= user.full_name %></h1>
<h3>joined: <%= user.created_at %></h3>
```

#### Section 42.2: Decorating a Model using SimpleDelegator

```ruby
class UserDecorator < SimpleDelegator
  attr_reader :view
  def initialize(user, view)
    __setobj__ @user
    @view = view
  end

  # new methods can call methods on the parent implicitly
  def full_name
    "#{ first_name } #{ last_name }"
  end
  # however, if you're overriding an existing method you need
  # to use __getobj__
  def created_at
    Time.use_zone(view.current_user.timezone) do
      __getobj__.created_at.strftime("%A, %d %b %Y %l:%M %p")
    end
  end
end
```

Some decorators rely on magic to wire-up this behavior, but you can make it more obvious where the presentationlogic is coming from by initializing the object on the page.

```ruby
<% user = UserDecorator.new(@user, self) %>
<h1><%= user.full_name %></h1>
<h3>joined: <%= user.created_at %></h3>
```

### Chapter 43: Elasticsearch

#### Section 43.1: Searchkick

If you want to setup quickly elasticsearch you can use the searchkick gem :

```ruby
gem 'searchkick'
```

Add searchkick to models you want to search.

```ruby
class Product < ActiveRecord::Base
  searchkick
end
```

Add data to the search index.

```ruby
Product.reindex
```

And to query, use:

```ruby
products = Product.search "apples"
products.each do |product|
  puts product.name
end
```

More information here : https://github.com/ankane/searchkick

#### Section 43.4: Introduction

ElasticSearch has a well-documented JSON API, but you'll probably want to use some libraries that handle that foryou:

- Elasticsearch - the official low level wrapper for the HTTP API
- Elasticsearch-rails - the official high level Rails integration that helps you to connect your Rails models with ElasticSearch using either ActiveRecord or Repository pattern
- Chewy - An alternative, non-official high level Rails integration that is very popular and arguably has better documentation

Let's use the first option for testing the connection:

```ruby
gem install elasticsearch
```

Then fire up the ruby terminal and try it out:

```ruby
require 'elasticsearch'

client = Elasticsearch::Client.new log: true
# by default it connects to http://localhost:9200

client.transport.reload_connections!
client.cluster.health

client.search q: 'test
```

### Chapter 44: React with Rails using react-rails gem

#### Section 44.1: React installation for Rails using rails_react gem

```ruby
gem 'react-rails'
# bundle install
# rails g react:install
```

This will:
create a components.js manifest file and a app/assets/javascripts/components/ directory, where you will put yourcomponents place the following in your application.js:

```ruby
//= require react
//= require react_ujs
//= require components
```

#### Section 44.2: Using react_rails within your application

```ruby
# config/environments/development.rb
MyApp::Application.configure do
  config.react.variant = :development
end

# config/environments/production.rb
MyApp::Application.configure do
  config.react.variant = :production
end

# To include add-ons, use this config:
MyApp::Application.configure do
  config.react.addons = true # defaults to false
end
```

Under the hood, react-rails uses ruby-babel-transpiler, for transformation.

#### Section 44.3: Rendering & mounting

```ruby
<%= react_component('HelloMessage', name: 'John') %>
<!-- becomes: -->
<div data-react-class="HelloMessage" data-react-props="{&quot;name&quot;:&quot;John&quot;}"></div>
```

### Chapter 45: Rails Cookbook - Advancedrails recipes/learnings and codingtechniques

#### Section 45.1: Playing with Tables using rails console

**View tables**

```ruby
ActiveRecord::Base.connection.tables
```

**Delete any table.**

```ruby
ActiveRecord::Base.connection.drop_table("users")
------------OR----------------------
ActiveRecord::Migration.drop_table(:users)
------------OR---------------------
ActiveRecord::Base.connection.execute("drop table users")
```

**Remove index from existing column**

```ruby
ActiveRecord::Migration.remove_index(:users, :name => 'index_users_on_country')
```

_\*\*Remove foreign key constraint_

```ruby
ActiveRecord::Base.connection.remove_foreign_key('food_items', 'menus')
```

**Add column**

```ruby
ActiveRecord::Migration.remove_column :table_name, :column_name

ActiveRecord::Migration.add_column :profiles, :profile_likes, :integer, :default => 0
```

#### Section 45.2: Rails methods - returning boolean values

**Again simple method returning boolean value**

```ruby
##this method return Boolean(NOTE THE !! signs before result)
def check_if_user_profile_is_complete
  !!User.includes( :profile_pictures,:address,:contact_detail).where("user.id = ?",self)
end
```

#### Section 45.3: Handling the error - undefined method `where'for #<Array:0x000000071923f8>

Sometimes we want to use a where query on a a collection of records returned which is not `ActiveRecord::Relation``.Hence we get the above error as Where clause is know to ActiveRecord and not to Array.

```ruby
UserProfiles.includes(:user=>:profile_pictures]).where(:active=>true).map(&:user).where.not(:id=>10)

# But using joins,will make it work
UserProfiles.includes(:user=>:profile_pictures]).where(:active=>true).joins(:user).where.not(:id=>10)
```

### Chapter 46: Multipurpose ActiveRecord columns

#### Section 46.1: Saving an object

If you have an attribute that needs to be saved and retrieved to database as an object, then specify the name ofthat attribute using the serialize method and it will be handled automatically.

The attribute must be declared as a text field.

In the model you must declare the type of the field (Hash or Array)

More info at: serialize >> apidock.com

#### Section 46.2: How To

In your migration

```ruby
class Users < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      ...
      t.text :preference
      t.text :tag
      ...
      t.timestamps
    end
  end
end
```

In your model

```ruby
class User < ActiveRecord::Base
  serialize :preferences, Hash
  serialize :tags, Array
end
```

### Chapter 47: Class Organization

#### Section 47.1: Service Class

**When to use Service Class**
Reach for Service Objects when an action meets one or more of these criteria:

- The action is complex (e.g. closing the books at the end of an accounting period)
- The action reaches across multiple models (e.g. an e-commerce purchase using Order, CreditCard and Customer objects)
- The action interacts with an external service (e.g. posting to social networks)
- The action is not a core concern of the underlying model (e.g. sweeping up outdated data after a certain timeperiod).
- There are multiple ways of performing the action (e.g. authenticating with an access token or password).

### Chapter 48: Shallow Routing

#### Section 48.1: Use of shallow

One way to avoid deep nesting (as recommended above) is to generate the collection actions scoped under theparent, so as to get a sense of the hierarchy, but to not nest the member actions

```ruby
resources :articles, shallow: true do
  resources :comments
  resources :quotes
  resources :drafts
end
```

The shallow method of the DSL creates a scope inside of which every nesting is shallow.

```ruby
shallow do
  resources :articles do
    resources :comments
    resources :quotes
    resources :drafts
  end
end
```

### Chapter 49: Model states: AASM

### Chapter 50: Rails 5 API Authetication

#### Section 50.1: Authentication with Railsauthenticate_with_http_token

```ruby
authenticate_with_http_token do |token, options|
  @user = User.find_by(auth_token: token)
end
```

You can test this endpoint with curl by making a request like

```bash
curl -IH "Authorization: Token token=my-token" http://localhost:3000
```

### Chapter 51: Testing Rails Applications

#### Section 51.1: Unit Test

Unit tests test parts of the application in isolation. usually a unit under test is a class or module.

```ruby
let(:gift) { create :gift }

describe '#find' do
  subject { described_class.find(user, Time.zone.now.to_date) }
  it { is_expected.to eq gift }
end
```

#### Section 51.2: Request Test

```ruby
it 'allows the user to set their preferences' do
  check 'Ruby'
  click_on 'Save and Continue'
  expect(user.languages).to eq ['Ruby']
end
```

### Chapter 52: Active Jobs

#### Section 52.2: Sample Job

```ruby
class UserUnsubscribeJob < ApplicationJob
  queue_as :default

  def perform(user)
    # this will happen later
    user.unsubscribe
  end
end
```

### Chapter 53: Rails frameworks over theyears

### Chapter 54: Nested form in Ruby on Rails

### Chapter 55: Factory Girl

#### Section 55.1: Defining Factories

If you have a ActiveRecord User class with name and email attributes, you could create a factory for it by makingthe FactoryGirl guess it:

```ruby
FactoryGirl.define do
  factory :user do # it will guess the User class
    name    "John"
    email   "john@example.com"
  end
end
```

Or you can make it explicit and even change its name:

```ruby
FactoryGirl.define do
  factory :user_jack, class: User do
    name      "Jack"
    email     "jack@example.com"
  end
end
```

Then in your spec you can use the FactoryGirl's methods with these, like this:

```ruby
# Build returns a non saved instance
user = build(:user)
```

### Chapter 56: Import whole CSV files fromspecific folder

#### Section 56.1: Uploads CSV from console command

### Chapter 57: Tools for Ruby on Rails codeoptimization and cleanup

#### Section 57.1: If you want to keep your code maintainable,secure and optimized, look at some gems for codeoptimization and cleanup :

**Bullet**

This one particularly blew my mind. The bullet gem helps you kill all the N+1 queries, as well as unnecessarily eager loaded relations. Once you install it and start visiting various routes in development, alert boxes with warnings indicating database queries that need to be optimized will pop out. It works right out of the box and is extremely helpful for optimizing your application.

**Rails Best Practices**

Static code analyzer for finding Rails specific code smells. It offers a variety of suggestions; use scope access, restrict auto-generated routes, add database indexes, etc. Nevertheless, it contains lots of nice suggestions that will give you a better perspective on how to re-factor your code and learn some best practices.

**Rubocop**

A Ruby static code analyzer which you can use to check if your code complies with the Ruby community code guidelines. The gem reports style violations through the command line, with lots of useful code refactoring goodies such as useless variable assignment, redundant use of Object#to_s in interpolation or even unused methodargument.
It's divided into 4 sub-analyzers (called cops): Style, Lint, Metrics and Rails.

### Chapter 58: ActiveJob

Active Job is a framework for declaring jobs and making them run on a variety of queuing backends. These jobs can be everything from regularly scheduled clean-ups, to billing charges, to mailings. Anything that can be chopped up into small units of work and run in parallel, really.

#### Section 58.1: Create the Job

```ruby
class GuestsCleanupJob < ApplicationJob
  queue_as :default

  def perform(*guests)
    # Do something later
  end
end
```

#### Section 58.2: Enqueue the Job

```ruby
# Enqueue a job to be performed as soon as the queuing system is free.
GuestsCleanupJob.perform_later guest
```

### Chapter 59: Active Model Serializers

ActiveModelSerializers, or AMS for short, bring 'convention over configuration' to your JSON generation. ActiveModelSerializers work through two components: serializers and adapters. Serializers describe which attributes and relationships should be serialized. Adapters describe how attributes and relationships should be serialized.

#### Section 59.1: Using a serializer

```ruby
class SomeSerializer < ActiveModel::Serializer
  attribute :title, key: :name
  attributes :body
end
```

### Chapter 60: Rails Engine - Modular Rails

#### Section 60.1: Create a modular app

```bash
rails new ModularTodo
cd ModularTodo && rails plugin new todo --mountable
mkdir engines && mv todo ./engines
```

### Chapter 61: Single Table Inheritance

Single Table Inheritance (STI) is a design pattern which is based on the idea of saving the data of multiple models which are all inheriting from the same Base model, into a single table in the database.

#### Section 61.2: Custom inheritance column

By default STI model class name is stored in a column named type. But its name can be changed by overriding inheritance_column value in a base class. E.g.:

```ruby
class User < ActiveRecord::Base
  self.inheritance_column = :entity_type # can be string as well
end

class Admin < User; end
```

#### Section 61.3: Rails model with type column and without STI

```ruby
class User < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
end
```

### Chapter 62: ActiveRecord Transactions

### Chapter 63: Turbolinks

#### Section 63.1: Binding to turbolink's concept of a page load

Turbolinks is a javascript library that makes navigating your web application faster. When you follow a link, Turbolinks automatically fetches the page, swaps in its <body>, and merges its <head>, all without incurring the cost of a full page load.

With turbolinks, the traditional approach to using:

```javascript
$(document).ready(function () {
  // awesome code
});
```

won't work. While using turbolinks, the $(document).ready() event will only fire once: on the initial page load. From that point on, whenever a user clicks a link on your website, turbolinks will intercept the link click event and make an ajax request to replace the <body> tag and to merge the <head> tags. The whole process triggers the notion of a "visit" in turbolinks land. Therefore, instead of using the traditional document.ready() syntax above, you'll have to bind to turbolink's visit event like so:

```javascript
// pure js
document.addEventListener('turbolinks:load', function () {
  // awesome code
});

// jQuery
$(document).on('turbolinks:load', function () {
  // your code
});
```

#### Section 63.2: Disable turbolinks on specific links

```html
// disables turbolinks for this one link
<a
  href="/"
  data-turbolinks="false"
  >Disabled</a
>

// disables turbolinks for all links nested within the div tag
<div data-turbolinks="false">
  <a href="/">I'm disabled</a>
  <a href="/">I'm also disabled</a>
</div>

// re-enable specific link when ancestor has disabled turbolinks
<div data-turbolinks="false">
  <a href="/">I'm disabled</a>
  <a
    href="/"
    data-turbolinks="true"
    >I'm re-enabled</a
  >
</div>
```

#### Section 63.3: Understanding Application Visits

Application visits are initiated by clicking a Turbolinks-enabled link, or programmatically by calling

```ruby
Turbolinks.visit(location)
```

#### Section 63.4: Cancelling visits before they begin

#### Section 63.5: Persisting elements across page loads

### Chapter 64: Friendly ID

FriendlyId is the "Swiss Army bulldozer" of slugging and permalink plugins for Active Record. It lets you create pretty URLs and work with human-friendly strings as if they were numeric ids. With FriendlyId, it's easy to make your application use URLs like:
http://example.com/states/washington

### Section 64.1: Rails Quickstart

#### Section 64.1: Rails Quickstart

```ruby
rails new my_app
cd my_app

gem 'friendly_id', '~> 5.1.0' # Note: You MUST use 5.0.0 or greater for Rails 4.0+

rails generate friendly_id
rails generate scaffold user name:string slug:string:uniq
rake db:migrate
```

**edit app/models/user.rb**

```ruby
class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
end

User.create! name: "Joe Schmoe"

# Change User.find to User.friendly.find in your controller
User.friendly.find(params[:id])
```

```bash
rails server
GET http://localhost:3000/users/joe-schmoe
# If you're adding FriendlyId to an existing app and need
# to generate slugs for existing users, do this from the
# console, runner, or add a Rake task:
User.find_each(&:save)
Finders are no longer overridden by default. If you want to do friendly finds, you must do Model.friendly.find rather than Model.find. You can however restore FriendlyId 4-style finders by using the :finders addon

friendly_id :foo, use: :slugged # you must do MyClass.frie1ndly.find('bar')
#or...
friendly_id :foo, use: [:slugged, :finders] # you can now do MyClass.find('bar')
```

A new "candidates" functionality which makes it easy to set up a list of alternate slugs that can be used to uniquely distinguish records, rather than appending a sequence. For example:

```ruby
class Restaurant < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :name,
      [:name, :city],
      [:name, :street, :city],
      [:name, :street_number, :street, :city]
    ]
  end
end
```

Set slug limit length using friendly_id gem?

```ruby
def normalize_friendly_id(string)
  super[0..40]
end

def should_generate_new_friendly_id?
  name_changed? || super
end
```

### Chapter 65: Securely storingauthentication keys

Many third-party APIs require a key, allowing them to prevent abuse. If they issue you a key, it's very important that you not commit the key into a public repository, as this will allow others to steal your key.

#### Section 65.1: Storing authentication keys with Figaro

### Chapter 66: Authenticate Api using Devise

```ruby
rails generate devise:install
rails generate devise MODEL
rake db:migrate
```

For more details go to: Devise Gem
**Authentication Token**
Authentication token is used to authenticate a user with a unique token, So Before we proceed with the logic first we need to add auth_token field to a Devise model

```ruby
rails g migration add_authentication_token_to_users

class AddAuthenticationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string, default: ""
    add_index :users, :auth_token, unique: true
  end
end
```

In app/controllers/application_controllers.rb

```ruby
protect_from_forgery with: :nul
```

will change this `:null` as we are not dealing with sessions.

### Chapter 67: Integrating React.js with RailsUsing Hyperloop

### Chapter 68: Change a default Railsapplication enviornment

### Chapter 69: Rails -Engines

#### Section 69.1: Famous examples are

### Chapter 70: Adding an Amazon RDS toyour rails application

#### Section 70.1: Consider we are connecting MYSQL RDS withyour rails application

**Steps to create MYSQL database**

1. Login to amazon account and select RDS service
2. Select Launch DB Instance from the instance tab
3. By defaul MYSQL Community Edition will be selected, hence click the SELECT button
4. Select the database purpose, say production and click next step
5. Provide the mysql version, storage size, DB Instance Identifier, Master Username and Password and click next step
6. Enter Database Name and click Launch DB Instance
7. Please wait until all the instance gets created. Once the instance gets created you will find an Endpoint, copy this entry point (which is referred as hostname)

**Installing connectors**

```ruby
gem 'mysql2'
```

**Configure your project's database.yml file**

```ruby
production:
  adapter: mysql2
  encoding: utf8
  database: <%= RDS_DB_NAME %>        # Which you have entered you creating database
  username: <%= RDS_USERNAME %>       # db master username
  password: <%= RDS_PASSWORD %>       # db master password
  host: <%= RDS_HOSTNAME %>           # db instance entrypoint
  port: <%= RDS_PORT %>               # db post. For MYSQL 3306
```

### Chapter 71: Payment feature in rails

#### Section 71.1: How to integrate with Stripe

```ruby
gem 'stripe'
```

Add initializers/stripe.rb file.

```ruby
require 'require_all'

Rails.configuration.stripe = {
  :publishable_key  => ENV['STRIPE_PUBLISHABLE_KEY'],
  :secret_key       => ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
```

**How to create a new customer to Stripe**

```ruby
Stripe::Customer.create({email: email, source: payment_token})
```

This code creates a new customer on Stripe with given email address and source.

payment_token is the token given from the client-side that contains a payment method like a credit card or bank account.
More info: Stripe.js client-side
**How to retrieve a plan from Stripe**

```ruby
Stripe::Plan.retrieve(stripe_plan_id)
```

### Chapter 72: Rails on docker

#### Section 72.1: Docker and docker-compose

First of all, we will need to create our `Dockerfile``

```Dockerfile
# Use the barebones version of Ruby 2.3.
FROM ruby:2.3.0-slim

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Nick Janetakis <nick.janetakis@gmail.com>

# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - nodejs: Compile assets
# - libpq-dev: Communicate with postgres through the postgres gem
RUN apt-get update && apt-get install -qq -y --no-install-recommends \
  build-essential nodejs libpq-dev git

# Set an environment variable to store where the app is installed to inside
# of the Docker image. The name matches the project name out of convention only.
ENV INSTALL_PATH /mh-backend
RUN mkdir -p $INSTALL_PATH

# This sets the context of where commands will be running in and is documented
# on Docker's website extensively.
WORKDIR $INSTALL_PATH

# We want binstubs to be available so we can directly call sidekiq and
# potentially other binaries as command overrides without depending on
# bundle exec.
COPY Gemfile* $INSTALL_PATH/

ENV BUNDLE_GEMFILE $INSTALL_PATH/Gemfile
ENV BUNDLE_JOBS 2
ENV BUNDLE_PATH /gembox

RUN bundle install

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . .

# Ensure the static assets are exposed to a volume so that nginx can read
# in these values later.
VOLUME ["$INSTALL_PATH/public"]

ENV RAILS_LOG_TO_STDOUT true

# The default command that gets run will be to start the Puma server.
CMD bundle exec puma -C config/puma.rb
```

Also, we will use docker-compose, for that, we will create docker-compose.yml

```yml
version: '2'

services:
  backend:
    links:
      -  #whatever you need to link like db
    build: .
    command: ./scripts/start.sh
    ports:
      - '3000:3000'
    volumes:
      - .:/backend
    volumes_from:
      - gembox
    env_file:
      - .dev-docker.env
    stdin_open: true
    tty: true
```

Just with these two files you will have enough to run `docker-compose up` and wake up your docker
