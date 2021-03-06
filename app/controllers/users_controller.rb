class UsersController < ApplicationController
  before_action :authorize_admin!, only: :index
  before_action :set_user, only: [:update, :destroy]

  respond_to :html

  def index
    @users = User.all.order('admin DESC', 'username').page(params[:page])
    respond_with(@users)
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'User wurde erfolgreich aktualisiert.'
    end

    respond_with(@user, location: users_url)
  end

  def destroy
    if @user.delete
      flash[:notice] = 'User wurde erfolgreich gelöscht.'
    end
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:admin)
  end
end
