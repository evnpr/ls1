class LsgitController < ApplicationController
  before_filter :get_users
  include SiteHelper
  def get_users
    @username = cookies[:username] 
  end
  
  def index
    

    r = params[:path]
    apps_name = r.split("-__-")[1]
    @apps_name = apps_name
  #  authenticate(Apps.where(:name => @apps_name).first.user.username, 
  #              Apps.where(:name => @apps_name).first.id, 
  #              User.where(:username => @username).first.id, 
  #              @username)

    user_id = User.where(:username => @username).first.id
    apps_id = Apps.where(:name => @apps_name).first.id
    @listNotif = Apps.find(apps_id).notifs
    
    an = AppsNotifs.where(:user_id => user_id)
    an.destroy
    
    render :json => @listNotif.to_json and return
    
    @r = r
    
    render :layout => false

    
  end
end





