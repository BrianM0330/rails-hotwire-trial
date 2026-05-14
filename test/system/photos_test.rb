require "application_system_test_case"

class PhotosTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @photo = photos(:two) # users(:one) does not like this photo yet
    @user.likes.where(photo: @photo).destroy_all
    @photo.update!(likes_count: @photo.likes.count)
  end

  test "signed in user can like from the gallery" do
    visit login_path

    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "password"
    click_button "Sign in"

    assert_text "Sign out" # wait for successful sign in

    # Go to photos grid
    visit photos_path

    find("#like_photo_#{@photo.id} button[aria-label='Like photo by #{@photo.photographer}']").click

    assert_selector "#like_photo_#{@photo.id} button[aria-label='Unlike photo by #{@photo.photographer}']"
    assert_selector "#like_photo_#{@photo.id}", text: @photo.reload.likes_count.to_s

    find("#like_photo_#{@photo.id} button[aria-label='Unlike photo by #{@photo.photographer}']").click

    assert_selector "#like_photo_#{@photo.id} button[aria-label='Like photo by #{@photo.photographer}']"
  end
end
