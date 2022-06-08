class DevicesController < ApplicationController
  def merge
    parent = current_user.devices.find(params[:parent])
    child = current_user.devices.find(params[:child])
    parent.songs << child.songs
    child.delete
    render notice: "Merged devices" 
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
