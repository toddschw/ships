class WelcomeController < ApplicationController
  def index
    render plain: "Welcome to the API"
  end
end
