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
        if @apps.first.nil?
            redirect_to "/" and return
        end
  end
  
  def submit
        #need to add security and auth for the not owner address, because they share same ls git user for push
        devserver = params[:devserver]
        devurl = params[:devurl]
        prodserver = params[:prodserver]
        produrl = params[:produrl]
        sftp_username = params[:sftp_username]
        sftp_password = params[:sftp_password]
        sftp_host = params[:sftp_host]
        sftp_location = params[:sftp_location]
        type_server = params[:type_server]
        appsname = params[:apps_name]
        
        if (appsname == '')
            flash[:server] = "please choose your apps"
            redirect_to "/server/index" and return
        end
        
        app = Apps.where(:name => appsname).first
        
        app.type_server = type_server
        
        if app.server.nil?
            s = Server.new(:apps_id => app.id)
            s.devserver = devserver
            s.devurl = devurl
            s.prodserver = prodserver  
            s.produrl = produrl
            s.save
        end
        
        if sftp_username != ""
                app.server.sftp_username = sftp_username           
        end
        unless sftp_password == ""
                app.server.sftp_password = sftp_password
        end
        unless sftp_host == ""
                app.server.sftp_host = sftp_host
        end
        unless sftp_location == ""
                app.server.sftp_location = sftp_location     
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
        
        if database_username == '' or database_name == '' or database_pwd == ''
            flash[:server] = 'cannot be blank'
            redirect_to "/server/index" and return
        end
        if Thedatabase.exists?(:database_username => database_username)
            flash[:server] = "The database username is already used"
            dbuserowner = Thedatabase.where(:database_username => database_username).first.apps.user.username
            if dbuserowner == @username
                sql = ActiveRecord::Base.connection();
                #sql.execute("DROP DATABASE IF EXISTS " + database_name + ";");
                sql.execute("DROP USER '"+ database_username +"'@'localhost';");
                flash[:server] = "The database username is already used then you change it"
            else
                redirect_to "/server/index" and return        
            end
        end
        
        if Thedatabase.exists?(:database_name => database_name)
            flash[:server] = "The database name is already used"
            dbuserowner = Thedatabase.where(:database_name => database_name).first.apps.user.username
            if dbuserowner == @username
                sql = ActiveRecord::Base.connection();
                #sql.execute("DROP DATABASE IF EXISTS " + database_name + ";");
                sql.execute("DROP Database "+ database_username +";");
                flash[:server] = "The database username is already used then you change it"
            else
                redirect_to "/server/index" and return        
            end
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
  
  def test
    
  end


end














