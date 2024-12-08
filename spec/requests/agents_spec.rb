require 'rails_helper'

RSpec.describe "Agents", type: :request do
  let(:user) { users(:pete) }
  let(:agent) { ai_agents(:general_assistant) }

  before { sign_in user }

  describe "GET /show" do
    it "returns http success" do
      get "/agents/#{agent.name}"
      expect(response).to have_http_status(:success)
    end
  end
end
