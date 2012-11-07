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
        listNotifAll = Apps.find(apps_id).notifs.order("id DESC")
        listNotif = User.where(:username => @username).first.notifs.order("id DESC")
        @listNotif = listNotifAll & listNotif
    end
    
    render :json => @listNotif.to_json and return
    
    @r = r
    
    render :layout => false

    
  end


  def deleteNotif 
    

    r = params[:path]
    notif_id = params[:notif_id]
    apps_name = r.split("-__-")[1]
    @apps_name = apps_name
  #  authenticate(Apps.where(:name => @apps_name).first.user.username, 
  #              Apps.where(:name => @apps_name).first.id, 
  #              User.where(:username => @username).first.id, 
  #              @username)

    user_id = User.where(:username => @username).first.id
    apps_id = Apps.where(:name => @apps_name).first.id

    nu = NotifsUsers.where(:user_id => user_id, :apps_id => apps_id)
    nu.destroy_all
    
    
    render :layout => false

    
  end
  
  
  
  def notifFromGit
        
        back = params[:r]
        redirect_to back and return
  end
  
  
  def syncdev
        
        back = params[:back]
        render :js => "alert(#{back})" and return
  end

end










