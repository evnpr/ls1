require 'digest/md5'
class UserController < ApplicationController

  before_filter :get_users
  
  def get_users
    @username = cookies[:username] 
  end
  
  
  def login
    if request.post?
        username = params[:username]
        pwd = Digest::MD5.hexdigest(params[:pwd])
        if User.exists?(:username => username, :password => pwd)
            cookies[:username] = username
            redirect_to "/user/index" and return
        elsif username == 'guest' and params[:pwd] == 'guest'
            cookies[:username] = username
            redirect_to "/user/index" and return
        end
        flash[:login] = "error login"
        redirect_to "/user/login" and return
    else
        if cookies[:username]
            redirect_to "/user/index" and return
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
    cookies.delete :username
    redirect_to "/"
  end
  
end






