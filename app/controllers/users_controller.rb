# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def show
    @posted_knowhows = current_user.knowhows.order(created_at: :desc)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = "\u30D7\u30ED\u30D5\u30A3\u30FC\u30EB\u3092\u66F4\u65B0\u3057\u307E\u3057\u305F"
      render :edit
    else
      flash.now[:alert] = "\u30D7\u30ED\u30D5\u30A3\u30FC\u30EB\u306E\u66F4\u65B0\u306B\u5931\u6557\u3057\u307E\u3057\u305F"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :profile)
  end
end
