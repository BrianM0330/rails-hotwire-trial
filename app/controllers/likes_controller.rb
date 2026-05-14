class LikesController < ApplicationController
  before_action :set_photo

  def create
    Current.user.likes.create_or_find_by(photo: @photo)
    @photo.reload
    render_like_button_or_redirect(liked: true)
  end

  def destroy
    Current.user.likes.find_by(photo: @photo)&.destroy
    @photo.reload
    render_like_button_or_redirect(liked: false)
  end

  private
    def set_photo
      @photo = Photo.find(params[:photo_id])
    end

    def render_like_button_or_redirect(liked:)
      @liked = liked

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: photos_path }
      end
    end
end
