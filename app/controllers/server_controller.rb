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
            s = Server.new(:apps_id => 'asd')
            s.save
        if app.server.nil?
            s = Server.new(:apps_id => app.id)
            s.save
        end
        app.server.devserver = devserver
        app.server.prodserver = prodserver
        app.save
        redirect_to "/server/index" and return
  end


end

