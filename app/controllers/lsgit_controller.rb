class LsgitController < ApplicationController
  before_filter :get_users
  include SiteHelper
  def get_users
    @username = cookies[:username] 
  end


  @@directory = "/var/www/ls/upload"

  
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
        redirect_to back and return
  end

  def gitToDB 
    
        r = params[:r]
        apps_name = r.split("-__-")[1]
        @apps_name = apps_name
        Dir.chdir("#{@@directory}/#{@apps_name}"){
           `git log > loggit` 
        }
        content = File.read('loggit')
        bCD = false #beforeCommitDescription
        content.each_line do |c|
            if bCD == true 
                if c =~ /^\s*$/ 
                    bCD = false 
                   # notifs = Apps.where(:name => @apps_name).first.notifs
                   # notifs.each do |n|
                   #    Notif.find(n.id).destroy
                   # end
                    if @commitMessage
                        newNotif = Notif.new(:name => @commitMessage)
                        newNotif.save
                        an = AppsNotifs.new(:notif_id => newNotif.id)
                        an.apps_id = Apps.where(:name => @apps_name).first.id
                        an.save
                    end
                else
                    @commitMessage = c          #this is the real commit 
                end
            else
                if c =~ /^\s*$/
                    bCD = true 
                else                        #to get the other parameters
                    if c.include? "commit"
                        codeCommit = c.split(" ")[1]
                    elsif c.include? "Author"
                        author = c.split(" ")[1]
                    elsif c.include? "Date"
                        date = c.split(" ")[1]
                    end
                end
            end
        end

        #redirect_to "/list?r=-__-"+@apps_name and return
        render :js => @commitMessage
  end

end



