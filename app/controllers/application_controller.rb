class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Checks if the parameters passed are valid
  def check_parameters
    @category_id = params[:category_id]
    @monetization = params[:monetization]
    @rank_position = params[:rank_position]

    monetizations = App::MONETIZATIONS

    if !(@category_id && @monetization)
      @errors = "Missing parameters"
    elsif !monetizations.include?(@monetization)
      @errors = "Bad monetization value. Options: [Free|Paid|Grossing]."
    elsif !(@category_id.to_i.to_s == @category_id)
      @errors = "Category Id should be numeric"
    elsif (@rank_position.present? && 
          !(@rank_position.to_i.to_s == @rank_position)) || 
          @rank_position.empty?
      @errors = "Rank position should be numeric"
    end

    render template: 'v1/errors/errors.json.jbuilder', status: 400 if @errors
  end
end
