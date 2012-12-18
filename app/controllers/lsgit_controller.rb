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

    def event_happen(apps_name)
        a = Apps.where(:name => apps_name).first
        if !Updateapp.exists?(:apps_id => a.id)
            return true
        end
        u = Updateapp.where(:apps_id => a.id).first
        if u.updated == true
            u.updated = false
            u.save
            return false 
        end
        return true
    end

    while event_happen(apps_name)
        sleep 2
    end
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
    
  # @r = r
  # render :layout => false

  end




  def deleteNotif 
    
    r = params[:path]
    #notif_id = params[:notif_id]
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

    return
    
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
                else                            #to get the other parameters
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
                    
                else
                    @commitMessage = c          #this is the real commit 
                end
            else
                if c =~ /^\s*$/
                    bCD = true 
                else                            #to get the other parameters
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
                    if @commitMessage and @author and @date and @codeCommit != ''
                        newNotif = Notif.new(:name => @commitMessage)
                        newNotif.date = @date
                        newNotif.commit_message = @codeCommit
                        newNotif.committer = @author
                        newNotif.save
                        an = AppsNotifs.new(:notif_id => newNotif.id)
                        an.apps_id = Apps.where(:name => @apps_name).first.id
                        an.save
                        @codeCommit = ''
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
  


  def updateApp
        @username = 'somebody' 
        apps = params[:apps]
        @apps_name = apps
        a = Apps.where(:name => apps).first

        if Updateapp.exists?(:apps_id => a.id)
            u = Updateapp.where(:apps_id => a.id).first
            u.updated = 1
            u.save
        end
        
        if !Updateapp.exists?(:apps_id => a.id)
            u = Updateapp.new
            u.updated = 1
            u.apps_id = a.id
            u.save
        end

        n = Notif.new(:committer => @username)
        #n.name = "<a href='/content?r=#{r}'>[commited] #{@username} edited #{path}</a>"
        n.name = "#{@username}"
        n.commit_message = "#{@username} push to GitSpan please reload the page if you are editing"
        n.save
        
        owner = Apps.where(:name => @apps_name).first.user.id
        nu = NotifsUsers.new(:user_id => owner)
        nu.notif_id = n.id
        nu.apps_id = Apps.where(:name => @apps_name).first.id
        nu.save
        collaborators = Apps.where(:name => @apps_name).first.collaborators
        collaborators.each do |c|
            nu = NotifsUsers.new(:user_id => c.user_id)
            nu.notif_id = n.id
            nu.apps_id = Apps.where(:name => @apps_name).first.id
            nu.save
        end
        an = AppsNotifs.new(:apps_id => Apps.where(:name => @apps_name).first.id)
        an.notif_id = n.id
        an.save
        
  end



end


