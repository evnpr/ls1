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
  
  
  def syncdev
        back = params[:back]
        apps_name = back.split("-__-")[1]
        @apps_name = apps_name
        Dir.chdir("#{@@directory}/#{@apps_name}"){
           `git add .`
           `git commit -m 'sync with Development Server from Letspan'`
           `git pull lsorigin2 master -f` 
           `git push ls1 master -f`
        }
        redirect_to back and return
  end




  def gitToDB 
        r = params[:r]
        apps_name = r.split("-__-")[1]
        @apps_name = apps_name
        `sudo chmod -R 777 /home/git/repositories/#{@apps_name}.git`

        Dir.chdir("#{@@directory}/#{@apps_name}"){
           `git stash` 
           `git pull ls1 master -f` 
        }

        Dir.chdir("/home/git/repositories/#{@apps_name}.git"){
           `git log > loggit` 
        }


        content = File.read("/home/git/repositories/#{@apps_name}.git/loggit")
        `sudo chmod -R 755 /home/git/repositories/#{@apps_name}.git`

        contentReverse = []
        i = 0
        bCD = true #beforeCommitDescription
        content.each_line do |c|
            if i == 100
                break
            end
            if bCD == true 
                if c =~ /^\s*$/ 
                    bCD = false 
                   # notifs.each do |n|
                   #    Notif.find(n.id).destroy
                   # end
                    if @commitMessage
                            i = i + 1
                    end
                else
                    @commitMessage = c          #this is the real commit 
                end
            else
                if c =~ /^\s*$/
                    bCD = true 
                else                        #to get the other parameters
                end
            end
            contentReverse << c 
        end


        contentReverse.reverse!

        notifs = Apps.where(:name => @apps_name).first.notifs
        notifs.destroy_all

        bCD = true #beforeCommitDescription
        contentReverse.each do |c|
            if bCD == true 
                if c =~ /^\s*$/ 
                    bCD = false 
                   # notifs.each do |n|
                   #    Notif.find(n.id).destroy
                   # end
                    if @commitMessage
                        newNotif = Notif.new(:name => @commitMessage)
                        newNotif.date = @date
                        newNotif.commit_message = @codeCommit
                        newNotif.committer = @author
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
                        @codeCommit = c.split(" ")[1]
                    elsif c.include? "Author"
                        @author = c.split(" ")[1]
                        if @author == 'Ubuntu'
                            @author = 'Letspan'
                        end
                    elsif c.include? "Date"
                        @date = c
                    end
                end
            end
        end

        redirect_to "/list?r=-__-"+@apps_name and return
  end



  def goToVersion

        r = params[:r]
        apps_name = r.split("-__-")[1]
        @apps_name = apps_name
        commit_code = params[:c]
        `sudo chmod -R 777 /home/git/repositories/#{@apps_name}.git`

        Dir.chdir("#{@@directory}/#{@apps_name}"){
           `git reset --hard #{commit_code}` 
           `git push ls1 master -f`
        }

        redirect_to "/list?r=-__-"+@apps_name and return

  end



end






