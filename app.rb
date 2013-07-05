require 'sinatra'
require 'active_support/inflector' # this gives us the singularize method we'll use below.

get '/say/hello' do # GET /say/hello
  erb :hello # renders /views/hello.erb wrapped in /views/layout.erb
end

get '/say/:name' do # GET /say/anything
  # the :name is a wildcard match. it will take /say/ followed by ANYTHING
  # that you put in the URL, and store that ANYTHING in a variable called params[:name]
  erb """
  <h1>Hello, #{params[:name]}</h1>
  <a href='/say/#{params[:name]}supercalifragilisticexpialidocious'>Link</a>
  """ # renders this 2 line string of HTML wrapped in /views/layout.erb

  # /views/layout.erb is always loaded automatically if it exists.
  # extra credit if you can turn it off or tell erb to use a different layout.
end




class ProductsController
  def index
    FakeRails.app.erb :products # renders /views/products.erb
  end

  def show
    FakeRails.app.erb :product # renders /views/product.erb
  end

  def delete
    # we haven't explored models yet
    # Product.find_by(name: params[:name]).destroy
  end

  def update
    # we haven't explored models yet
    # Product.update_attributes(params)
  end
end

class OrdersController
  def index
    FakeRails.app.erb :orders
  end

  def show
    FakeRails.app.erb :order
  end
end




class FakeRails < Sinatra::Application
  before { settings.set(:app, self) } # a super hack to get erb to work

  def self.resources(resource_name, controller_class)
    plural_name = resource_name.to_sym # :products
    singular_name = resource_name.to_s.singularize.to_sym # :product

    get "/#{plural_name}" do # GET /products
      # first get a real, concrete controller object based on the abstract controller class
      controller_instance = controller_class.new
      # now call index on the controller object. this is defined in the controller class above
      controller_instance.index
    end

    get "/#{singular_name}/:id" do # GET /product/1
      controller_instance = controller_class.new
      controller_instance.show
    end

    put "/#{singular_name}/:id" do # PUT /product/1
      controller_instance = controller_class.new
      controller_instance.update
    end

    delete "/#{singular_name}/:id" do # DELETE /product/1
      controller_instance = controller_class.new
      controller_instance.delete
    end
  end

  resources :products, ProductsController # adds the above four routes
  resources :orders, OrdersController # adds four MORE routes, for a total of 8

  run!
end
