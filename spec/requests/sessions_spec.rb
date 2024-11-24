require "rails_helper"

RSpec.describe SessionsController, type: :request do
  let(:user) { users(:lazaro_nixon) }

  describe "#index" do
    it "should get index" do
      sign_in(user)

      get sessions_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "#new" do
    it "should get new" do
      get sign_in_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "#create" do
    it "should sign in" do
      perform_enqueued_jobs do
        post sign_in_url, params: { email: user.email, password: "Secret1*3*5*" }

        expect(response).to redirect_to(root_path)

        get root_url
        expect(response).to have_http_status(:success)

        expect(last_email.to.first).to eq(user.email)
        expect(last_email.subject).to eq("New sign-in to your account")
      end
    end

    it "should not sign in with wrong credentials" do
      post sign_in_url, params: { email: user.email, password: "SecretWrong1*3" }
      expect(response).to redirect_to(sign_in_url(email_hint: user.email))
      expect(flash[:alert]).to eq("That email or password is incorrect")
    end
  end

  describe "#destroy" do
    it "should sign out" do
      sign_in(user)

      delete session_url(user.sessions.last)
      expect(response).to redirect_to(sessions_url)

      follow_redirect!
      assert_redirected_to sign_in_url
    end
  end
end
