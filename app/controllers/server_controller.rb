class ServerController < ApplicationController
  before_filter :get_users

  def get_users
    @username = cookies[:username] 
  end

  @@directory = "/var/www/ls/upload"

  def index
        @apps = User.where(:username => @username).first.appss
  end
  
  def submit
        devserver = params[:devserver]
        prodserver = params[:prodserver]
        appsname = params[:apps_name]
        
        app = Apps.where(:name => appsname).first
        if app.server.nil?
            s = Server.new(:apps_id => app.id)
            s.save
        end
        
        
        Dir.chdir(@@directory+"/"+appsname){
            unless devserver == ''
                `git remote rm lsorigin2`
                `git remote add lsorigin2 #{devserver}`
                app.server.devserver = devserver
            end
            unless prodserver == ''
                app.server.prodserver = prodserver
                `git remote add prodlsorigin2 #{prodserver}`                
            end
            app.server.save
        }
        #need to add security and auth for the not owner address, because they share same ls git user for push
        redirect_to "/server/index" and return
  end


end

