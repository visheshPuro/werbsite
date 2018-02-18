class SessionsController < ApplicationController

	def create
	  @current_user = User.find_by_login(params[:login].downcase)
	  if @current_user.blank? || params[:password] !=  @current_user.password_hash
	    @current_user = nil
	    render :action => "new"
	  else
	    session[:user_id] = @current_user.id
	    session[:close_time] = 1800.seconds.from_now

	    if @current_user.last_login.nil?
	      @login = LastLogin.new
	      @login.user_id = @current_user.id
	      @login.login_at = Time.now
	      @login.save
	    else
	      @login = @current_user.last_login
	      @login.last_at = @login.login_at
	      @login.login_at = Time.now
	      @login.login_count += 1
	      @login.save
	    end

	    if session[:return_to]
	      redirect_to session[:return_to], :protocol => USE_PROTOCOL
	      session[:return_to] = nil
	    else
	    end
	  end
	end
end
