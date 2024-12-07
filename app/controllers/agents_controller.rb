class AgentsController < ApplicationController
  def show
  end

  def create
    @message = params[:message]
  end
end
