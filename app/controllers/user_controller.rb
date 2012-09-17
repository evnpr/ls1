require 'digest/md5'
class UserController < ApplicationController

  before_filter :get_users
  
  def get_users
    @username = session[:username] 
  end
  
  
  def login
    if request.post?
        username = params[:username]
        pwd = params[:pwd]
        if User.exists?(:username => username, :password => pwd)
            session[:username] = username
            redirect_to "/user/index" and return
        end
        flash[:login] = "error login"
        redirect_to "/user/login" and return
    else
        if session[:username]
            redirect_to "/" and return
        end
    end
  end
  
  def index
    if User.exists?(:username => @username)
        @apps = User.where(:username => @username).first.appss
    end
  end

  def register
  end
  
  def logout
    session[:username] = nil
    redirect_to "/"
  end
  
end



