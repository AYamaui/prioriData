class V1::PublishersController < V1::BaseController

  before_action :check_parameters

  def index
    begin
      @top_publishers = Publisher.get_top_publishers(@category_id, 
                                                      @monetization)
      render json: @top_publishers

    rescue
      @errors = "Something went wrong!"
      render template: 'v1/errors/errors.json.jbuilder'
    end
  end

end