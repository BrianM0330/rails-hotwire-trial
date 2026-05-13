class LikesController < ApplicationController
  before_action :set_photo

  def create
    Current.user.likes.create_or_find_by(photo: @photo)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @photo }
    end
  end

  def destroy
    Current.user.likes.find_by(photo: @photo)&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @photo }
    end
  end

  private
    def set_photo
      @photo = Photo.find(params[:photo_id])
    end
end
