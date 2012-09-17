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
    if request.post?
        username = params[:username]
        pwd = Digest::MD5.hexdigest(params[:pwd])
        if User.exists?(:username => username, :password => pwd)
            redirect_to "/user/login" and return
        elsif username == '' || params[:pwd] == ''
            flash[:register] = "can not be blank"
        else
            u = User.new(:username => username)
            u.password = pwd
            u.save
            cookies[:username] = username
            redirect_to "/user/index" and return
        end
        flash[:register] = "error registration"
        redirect_to "/user/register" and return
    else
        if cookies[:username]
            redirect_to "/user/index" and return
        end
    end
  end
  
  def logout
    cookies.delete :username
    redirect_to "/"
  end
  
end








