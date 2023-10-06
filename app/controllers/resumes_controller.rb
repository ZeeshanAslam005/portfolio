class ResumesController < ApplicationController
  def index
    @title = Rails.application.credentials.title
  end

  def contact
  end
end
