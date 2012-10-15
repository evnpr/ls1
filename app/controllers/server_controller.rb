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
                `git remote rm prodlsorigin2`                
                `git remote add prodlsorigin2 #{prodserver}`                
            end
            app.server.save
        }
        #need to add security and auth for the not owner address, because they share same ls git user for push
        redirect_to "/server/index" and return
  end
  
  def submitdb
        database_name = params[:dbname]
        database_username = params[:dbuser]
        database_pwd = params[:dbpwd]
        appsname = params[:apps_name]
        
        app = Apps.where(:name => appsname).first
        if app.thedatabase.nil?
            td = Thedatabase.new(:apps_id => app.id)
            td.database_name = database_name
            td.database_username = database_username
            td.save
        end
        
        if Thedatabase.exists?(:database_username => database_username)
            flash[:server] = "The database username is already used"
            redirect_to "/server/index" and return        
        end
        
        if Thedatabase.exists?(:database_name => database_name)
            flash[:server] = "The database name is already used"
            redirect_to "/server/index" and return        
        end
        
        
        sql = ActiveRecord::Base.connection();
        sql.execute("DROP DATABASE IF EXISTS " + database_name + ";");
        sql.execute("CREATE DATABASE IF NOT EXISTS " + database_name + ";");
        sql.execute("GRANT ALL ON " + database_name + ".* TO " + database_username + "@localhost IDENTIFIED BY '" + database_pwd +"';");
        
        flash[:server] = "success"
        redirect_to "/server/index" and return      
        
  end


end


