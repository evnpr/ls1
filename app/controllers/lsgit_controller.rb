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
    if NotifsUsers.exists?(:user_id => user_id)
        listNotifAll = Apps.find(apps_id).notifs
        listNotif = User.where(:username => @username).first.notifs
        @listNotif = listNotif & listNotifAll
    end
    nu = NotifsUsers.where(:user_id => user_id)
    nu.destroy_all
    
    render :json => @listNotif.to_json and return
    
    @r = r
    
    render :layout => false

    
  end
end





