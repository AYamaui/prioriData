require "rails_helper"

RSpec.describe V1::AppsController, type: :controller do

  let(:json) { JSON.parse(response.body) }

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index, { category_id: "6001", monetization: 'Free', format: :json }

      unless json.empty?

        expect(json.size).to eq(200)

        expect(json.all? { |k,v| 
                              v.has_key?("average_user_rating") }).to eq(true)
        expect(json.any? { |k,v| v.has_key?("description") }).to eq(true)   
        expect(json.any? { |k,v| v.has_key?("small_icon_url") }).to eq(true)   
        expect(json.any? { |k,v| v.has_key?("publisher_name") }).to eq(true)   
        expect(json.any? { |k,v| v.has_key?("price") }).to eq(true)   
        expect(json.any? { |k,v| v.has_key?("version_number") }).to eq(true)   
        expect(json.any? { |k,v| 
                              v.has_key?("average_user_rating") }).to eq(true)   
      end

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "responds successfully with an HTTP 200 status code. 
        The rank_position parameter is present" do
      get :index, { category_id: "6001", 
                    monetization: 'Paid', 
                    rank_position: '3', 
                    format: :json }

      unless json.empty?
        expect(json).to have_key("app_name")                  
        expect(json).to have_key("description")                  
        expect(json).to have_key("small_icon_url")                  
        expect(json).to have_key("publisher_name")                  
        expect(json).to have_key("price")                  
        expect(json).to have_key("version_number")                  
        expect(json).to have_key("average_user_rating")   
      end               

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "responds unsuccessfully with an HTTP 400 status code.
        The monetization parameter is missing" do
      get :index, { category_id: "6001", format: :json }
      expect(response).not_to be_success
      expect(response).to have_http_status(400)
    end
  end
end