require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '/api/*', headers: :any, methods: [:get, :post, :put]
  end
end

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
