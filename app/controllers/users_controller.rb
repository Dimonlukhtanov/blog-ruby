class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def ban_time(time)
    Time.zone.now + Time.zone.at(time)
  end

  def ban
    return unless user_signed_in?
    @user = User.find(params[:id])
    @time_zone = Time.zone.at(ban_time(3600 * 24 * 14))
    @user.update(ban: @time_zone)
    @user.ban = @time_zone
    @user.save
    redirect_to users_path(@user.id), success: "Успешно, пользователь: #{@user.username} получил бан до #{@user.ban}"
  end

  def unban
    return unless user_signed_in?
    @user = User.find(params[:id])
    @user.update(ban: nil)
    @user.ban = nil
    @user.save
    redirect_to users_path(@user.id), success: "Успешно, пользователь: #{@user.username} разбанен "
  end

end