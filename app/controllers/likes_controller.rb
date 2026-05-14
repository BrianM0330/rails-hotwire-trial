class LikesController < ApplicationController
  before_action :set_photo

  def create
    Current.user.likes.create_or_find_by(photo: @photo)
    redirect_back fallback_location: photos_path
  end

  def destroy
    Current.user.likes.find_by(photo: @photo)&.destroy
    redirect_back fallback_location: photos_path
  end

  private
    def set_photo
      @photo = Photo.find(params[:photo_id])
    end
end
