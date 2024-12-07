require 'rails_helper'

RSpec.describe "Agents", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/agents/show"
      expect(response).to have_http_status(:success)
    end
  end

end
