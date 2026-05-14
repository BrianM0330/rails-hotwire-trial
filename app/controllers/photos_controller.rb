class PhotosController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  def index
    @photos = Photo.order(:id)
    @liked_photo_ids = liked_photo_ids_for(@photos)
  end

  def show
    @photo = Photo.find(params[:id])
    @liked_photo_ids = liked_photo_ids_for(@photo)
  end

  private
    def liked_photo_ids_for(photos)
      return Set.new unless Current.user

      Current.user.likes.where(photo: photos).pluck(:photo_id).to_set
    end
end
