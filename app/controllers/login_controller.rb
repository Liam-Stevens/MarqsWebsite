class LoginController < ApplicationController
  def index
    if params[:id] != nil
      session[:id] = params[:id]
      session[:logout] = false
    end

    if Student.exists?(student_id: session[:id])
      session[:marker] = false
      redirect_to "/students/"+session[:id]
    elsif Marker.exists?(marker_id: session[:id])
      session[:marker] = true
      redirect_to "/markers/"+session[:id]
    elsif session[:logout] == false
      @failure = "Not a valid ID"
    end

  end

  #Logs the user out and nukes the session
  def show
    session.clear
    session[:logout] = true
    redirect_to "/login"
  end

end

