class LsgitController < ApplicationController
  before_filter :get_users
  include SiteHelper
  def get_users
    @username = cookies[:username] 
  end
  
  def index
    unless @username
        redirect_to "/"
    end
    r = params[:thisfile]
    commit = params[:commit]
    apps_name = r.split("-__-")[1]
    @apps_name = apps_name
    authenticate(Apps.where(:name => @apps_name).first.user.username, 
                Apps.where(:name => @apps_name).first.id, 
                User.where(:username => @username).first.id, 
                @username)
    path = r.gsub(/\-\_\_\-/, "\/")
  end
end

