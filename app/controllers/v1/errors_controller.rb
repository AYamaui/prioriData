class V1::ErrorsController < ApplicationController

  def invalid_url
    @errors = "Invalid URL"
    render template: 'v1/errors/errors.json.jbuilder', status: 400
  end
end