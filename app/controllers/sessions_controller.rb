class SessionsController < ApplicationController
  def create
    user = user.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.user_id
      render json: { message: 'Logged in successfully' }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def destroy
    session[:user_id] = nil
    render json: { message: 'Logged out successfully' }
  end
end
