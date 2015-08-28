require "rails_helper"

RSpec.describe V1::PublishersController, type: :controller do

  let(:json) { JSON.parse(response.body) }

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index, { category_id: "6001", monetization: 'Free', format: :json }

       unless json.empty?

        expect(json.size).to be <= 200

        expect(json.all? { |k,v| v.has_key?("publisher_name") }).to eq(true)
        expect(json.any? { |k,v| v.has_key?("rank") }).to eq(true)   
        expect(json.any? { |k,v| v.has_key?("number_of_apps") }).to eq(true)   
        expect(json.any? { |k,v| v.has_key?("app_names") }).to eq(true)  
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