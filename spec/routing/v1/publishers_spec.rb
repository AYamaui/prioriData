require 'rails_helper'

RSpec.describe "routing to publishers", type: :routing do
  it "routes /categories/:category_id/publishers?monetization=:monetization 
      to publishers#index" do
    expect(get: "/categories/6001/publishers?monetization=Free").to route_to(
      controller: "v1/publishers",
      action: "index",
      category_id: "6001",
      monetization: "Free",
      format: :json
    )
  end

  it "routes /bad_url to errors#invalid_url" do
    expect(get: "/bad_url").to route_to(
      controller: "v1/errors",
      action: "invalid_url",
      path: "bad_url",
      format: :json
    )
  end

  it "does not route /categories/:category_id/publishers/bad_url to 
      publishers#index, instead errors#invalid_url" do
    expect(get: "categories/6001/publishers/bad_url").to route_to(
      controller: "v1/errors",
      action: "invalid_url",
      path: "categories/6001/publishers/bad_url",
      format: :json
    )
  end
end