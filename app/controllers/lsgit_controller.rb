class LsgitController < ApplicationController
  before_filter :get_users
  include SiteHelper
  def get_users
    @username = cookies[:username] 
  end
  
  def index
    


    @apps_name = 'ls1'
  #  authenticate(Apps.where(:name => @apps_name).first.user.username, 
  #              Apps.where(:name => @apps_name).first.id, 
  #              User.where(:username => @username).first.id, 
  #              @username)

    user_id = User.where(:username=>@username).first.id
    apps_id = Apps.where(:name => @apps_name).first.id
    @listNotif = Apps.find(apps_id).notifs
    
    render :json => @listNotif.to_json and return
    
    @r = r
    
    render :layout => false

    
  end
end





