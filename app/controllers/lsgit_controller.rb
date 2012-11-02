class LsgitController < ApplicationController
  before_filter :get_users
  include SiteHelper
  def get_users
    @username = cookies[:username] 
  end
  
  def index
    

    r = params[:path]
  #  apps_name = r.split("-__-")[1]
  #  @apps_name = apps_name
  #  authenticate(Apps.where(:name => @apps_name).first.user.username, 
  #              Apps.where(:name => @apps_name).first.id, 
  #              User.where(:username => @username).first.id, 
  #              @username)

    user_id = User.where(:username=>@username).first.id
    @listNotif = User.find(user_id).notifs
    
    render :json => @listNotif
  #  @r = r
  #  render :nothing => true
    render :layout => false

    
  end
end




