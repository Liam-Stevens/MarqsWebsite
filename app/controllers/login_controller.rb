class LoginController < ApplicationController
  def index
    if params[:id] != nil
      session[:id] = params[:id]
    end

    if Student.exists?(student_id: session[:id])
      redirect_to "/students/"+session[:id]
    elsif Marker.exists?(uni_id: session[:id])
      redirect_to "/markers/"+session[:id]
    else
      @failure = "Not a valid ID"
    end

  end

  def show
    session.clear
    redirect_to "/login"
  end

end

