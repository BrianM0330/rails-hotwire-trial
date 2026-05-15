require "application_system_test_case"

class PhotosTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @photo = photos(:two)
    @user.likes.where(photo: @photo).destroy_all
    users(:two).likes.find_or_create_by!(photo: @photo)
    Photo.reset_counters(@photo.id, :likes)
  end

  test "signed in user can like from the gallery" do
    visit login_path

    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "password"
    click_button "Sign in"

    assert_text "Sign out" # wait for successful sign in

    # Go to photos grid
    visit photos_path

    assert_selector "#like_photo_#{@photo.id}", text: "1"
    assert_selector "#like_photo_#{@photo.id} button[aria-label='Like photo by #{@photo.photographer}']"

    within "#like_photo_#{@photo.id}" do
      find("button[aria-label='Like photo by #{@photo.photographer}']").click
    end

    assert_selector "#like_photo_#{@photo.id} button[aria-label='Unlike photo by #{@photo.photographer}']"
    assert_selector "#like_photo_#{@photo.id}", text: "2"
  end

  test "signed in user sees existing liked state in the gallery" do
    @user.likes.create!(photo: @photo)
    Photo.reset_counters(@photo.id, :likes)

    visit login_path

    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "password"
    click_button "Sign in"

    assert_text "Sign out"

    visit photos_path

    assert_selector "#like_photo_#{@photo.id} button[aria-label='Unlike photo by #{@photo.photographer}']"
    assert_selector "#like_photo_#{@photo.id}", text: "2"
  end
end
