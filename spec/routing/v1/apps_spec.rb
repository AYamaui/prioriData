require 'rails_helper'

RSpec.describe "routing to apps", type: :routing do
  it "routes /categories/:category_id/apps?monetization=:monetization 
      to apps#index" do
    expect(get: "/categories/6001/apps?monetization=Free").to route_to(
      controller: "v1/apps",
      action: "index",
      category_id: "6001",
      monetization: "Free",
      format: :json
    )
  end

  it "routes /categories/:category_id/apps
      ?monetization=:monetization&rank_position=:rank_position to apps#index" do
    expect(get: "/categories/6001/apps?monetization=Free&rank_position=3").to route_to(
      controller: "v1/apps",
      action: "index",
      category_id: "6001",
      monetization: "Free",
      rank_position: "3",
      format: :json
    )
  end

  it "does not route /categories/:category_id/apps/bad_url to 
      apps#index, instead errors#invalid_url" do
    expect(get: "categories/6001/apps/bad_url").to route_to(
      controller: "v1/errors",
      action: "invalid_url",
      path: "categories/6001/apps/bad_url",
      format: :json
    )
  end
end