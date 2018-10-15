class SettingsBoxesController < ApplicationController
  before_action :logged_in_user, only: [:update]
  
  def update
    @settings_box = current_user.settings_box
    if @settings_box.update_attributes(settings_params)
      flash[:success] = "Your settings have been saved"
      redirect_to profile_path
    else
      redirect_to settings_path
    end
  end
  
  private
    def settings_params
      params.require(:settings_box).permit(:receive_email)
    end
end
