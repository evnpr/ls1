class ServerController < ApplicationController
  before_filter :get_users

  def get_users
    @username = cookies[:username] 
  end

  @@directory = "/var/www/ls/upload"

  def index
        unless @username
            redirect_to "/" and return
        end
        @apps = User.where(:username => @username).first.appss
  end
  
  def submit
        #need to add security and auth for the not owner address, because they share same ls git user for push
        devserver = params[:devserver]
        devurl = params[:devurl]
        prodserver = params[:prodserver]
        produrl = params[:produrl]
        appsname = params[:apps_name]
        
        app = Apps.where(:name => appsname).first
        if app.server.nil?
            s = Server.new(:apps_id => app.id)
            s.devserver = devserver
            s.devurl = devurl
            s.prodserver = prodserver  
            s.produrl = produrl
            s.save
        end
        
        
        Dir.chdir(@@directory+"/"+appsname){
            unless devserver == ''
                `git remote rm lsorigin2`
                `git remote add lsorigin2 #{devserver}`
                unless app.server.nil?
                    app.server.devserver = devserver
                end
            end
            unless devurl == ''
                unless app.server.nil?
                    app.server.devurl = devurl
                end
            end
            unless prodserver == ''
                `git remote rm prodlsorigin2`                
                `git remote add prodlsorigin2 #{prodserver}`
                unless app.server.nil?
                    app.server.prodserver = prodserver
                end
            end
            unless produrl == ''
                unless app.server.nil?
                    app.server.produrl = produrl
                end
            end
            unless app.server.nil?
                app.server.save
            end
        }
        flash[:server] = "success"
        redirect_to "/server/index" and return
  end
  
  def submitdb
        #need to add security and auth for the not owner address, because they can access every database if have the password
        database_name = params[:dbname]
        database_username = params[:dbuser]
        database_pwd = params[:dbpwd]
        appsname = params[:apps_name]
        

        if Thedatabase.exists?(:database_username => database_username)
            flash[:server] = "The database username is already used"
            redirect_to "/server/index" and return        
        end
        
        if Thedatabase.exists?(:database_name => database_name)
            flash[:server] = "The database name is already used"
            redirect_to "/server/index" and return        
        end
        
        app = Apps.where(:name => appsname).first
        if app.thedatabase.nil?
            td = Thedatabase.new(:apps_id => app.id)
            td.database_name = database_name
            td.database_username = database_username
            td.database_pwd = database_pwd
            td.save
        else
            app.thedatabase.database_name = database_name
            app.thedatabase.database_username = database_username
            app.thedatabase.database_pwd = database_pwd
            app.thedatabase.save
        end
        
        sql = ActiveRecord::Base.connection();
        #sql.execute("DROP DATABASE IF EXISTS " + database_name + ";");
        sql.execute("CREATE DATABASE IF NOT EXISTS " + database_name + ";");
        sql.execute("GRANT ALL ON " + database_name + ".* TO " + database_username + "@localhost IDENTIFIED BY '" + database_pwd +"';");
        
        flash[:server] = "success"
        redirect_to "/server/index" and return      
        
  end


end










