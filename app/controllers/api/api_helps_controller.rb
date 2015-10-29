class Api::ApiHelpsController < ApplicationController
  def index
  end

  def docs
  	@host = "http://www.lvh.me:3000"
  end
end

