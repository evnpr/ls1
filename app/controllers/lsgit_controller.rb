class LsgitController < ApplicationController
  before_filter :get_users
  include SiteHelper
  def get_users
    @username = cookies[:username] 
  end
  
  def index
    unless @username
        redirect_to "/"
    end
    username = params[:username]
    r = params[:thisfile]
    apps_name = r.split("-__-")[1]
    @apps_name = apps_name
    authenticate(Apps.where(:name => @apps_name).first.user.username, 
                Apps.where(:name => @apps_name).first.id, 
                User.where(:username => @username).first.id, 
                @username)
    user_id = User.where(:username=>username).first.id
    n = Notifread.where(:user_id => user_id)
    @listNotif = n
    
    n.destroy
    
  end
end
