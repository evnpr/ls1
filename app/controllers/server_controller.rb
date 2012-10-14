class ServerController < ApplicationController
  before_filter :get_users

  def get_users
    @username = cookies[:username] 
  end


  def index
        @apps = User.where(:username => @username).first.appss
  end
  
  def submit
        #post 
  end


end

