class UserController < ApplicationController

  before_filter :get_users
  
  def get_users
    @username = session[:username] 
  end
  
  
  def login
    if request.post?
        username = params[:username]
        pwd = params[:pwd]
        session[:username] = username
        redirect_to "/" and return
    else
        if session[:username]
            redirect_to "/" and return
        end
    end
  end
  
  def index
  end

  def register
  end
  
  def logout
    session[:username] = nil
    redirect_to "/"
  end
  
end


