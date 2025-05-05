class HomeController < ApplicationController
  def index
    render json: { message: 'Welcome to the eSignature API' }
  end
end
