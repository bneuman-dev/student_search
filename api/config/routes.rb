Rails.application.routes.draw do
  mount StudentSearchApi::StudentAPI::API => "/api"

  match "*path", to: -> (env) { [404, {}, ['{"errors": ["not_found"]}']] }, via: :all
end
