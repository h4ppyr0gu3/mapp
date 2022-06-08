class DevicesController < ApplicationController
  def merge
    parent = current_user.devices.find_by(user_agent: params[:parent])
    child = current_user.devices.find_by(user_agent: params[:child])
    if parent.id != child.id
      parent.songs >> child.songs
      redirect_to profile_path,notice: "Merged devices" 
    else
      redirect_to profile_path, alert: "The devices are not unique"
    end
  end

  def wipe_device
    current_user.devices.find(params[:id]).songs = []
    redirect_to profile_path, notice: "Wiped device" 
  end

  def destroy
    current_user.devices.find(params[:id]).delete
    redirect_to profile_path, notice: "Deleted device" 
  end
end
