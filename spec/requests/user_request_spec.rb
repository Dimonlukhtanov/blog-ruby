require 'rails_helper'

RSpec.describe 'UserController', type: :request do
  describe 'GET sign_up' do
    it 'success sign up' do
      get '/users/sign_up'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET sign_in' do
    it 'success sign in' do
      get '/users/sign_in'
      expect(response).to have_http_status(:success)
    end
  end
end
