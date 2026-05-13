class PhotosController < ApplicationController
  before_action :redirect_unauthenticated_to_root

  def index
  end

  private
    def redirect_unauthenticated_to_root
      redirect_to root_path unless authenticated?
    end
end
