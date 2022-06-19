# frozen_string_literal: true

class DevicesController < ApplicationController
  def merge
    if parent.id == child.id
      redirect_to profile_path, alert: "The devices are not unique"
    else
      merge_devices
      redirect_to profile_path, notice: "Merged devices"
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

  private

  def merge_devices
    unique_parent = find_uniq_ids(parent, child)
    unique_child = find_uniq_ids(parent, child)
    unique_parent.map { |s| Device_songs.create!(device_id: child.id, song_id: s) }
    unique_child.map { |s| Device_songs.create!(device_id: parent.id, song_id: s) }
  end

  def find_uniq_ids(base, other)
    base.songs.where.not(id: other.songs.ids)
  end

  def parent
    @parent ||= current_user.devices.find_by(user_agent: params[:parent])
  end

  def child
    @child ||= current_user.devices.find_by(user_agent: params[:child])
  end
end
