class PhotosController < ApplicationController
  allow_unauthenticated_access only: :show

  def index
    @photos = Photo.order(created_at: :desc)
    @liked_photo_ids = Current.user.likes.where(photo: @photos).pluck(:photo_id).to_set
  end

  def show
    @photo = Photo.find(params[:id])
    @liked_photo_ids = Current.user ? Current.user.likes.where(photo: @photo).pluck(:photo_id).to_set : Set.new
  end
end
