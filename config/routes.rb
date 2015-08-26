PrioriData::Application.routes.draw do
  
  root 'application#index'

  # Version 1
  api_version(module: 'V1',
              header: {name: 'Accept',
                       value: 'application/vnd.api.prioridata.com+json; version=1'},
              defaults: {format: :json},
              default: true) do
  end
end
