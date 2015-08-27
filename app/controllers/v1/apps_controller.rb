class V1::AppsController < V1::BaseController

  before_action :check_parameters

  def index

    begin
      @top_apps = App.get_top_apps(@category_id, @monetization, @rank_position)
      render json: @top_apps

    rescue
      @errors = "Something went wrong!"
      render template: 'v1/errors/errors.json.jbuilder'
    end
    
  end

end