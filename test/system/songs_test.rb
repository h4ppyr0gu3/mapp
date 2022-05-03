require "application_system_test_case"

class SongsTest < ApplicationSystemTestCase
  setup do
    @song = songs(:one)
  end

  test "visiting the index" do
    visit songs_url
    assert_selector "h1", text: "Songs"
  end

  test "should create song" do
    visit songs_url
    click_on "New song"

    click_on "Create Song"

    assert_text "Song was successfully created"
    click_on "Back"
  end

  test "should update Song" do
    visit song_url(@song)
    click_on "Edit this song", match: :first

    click_on "Update Song"

    assert_text "Song was successfully updated"
    click_on "Back"
  end

  test "should destroy Song" do
    visit song_url(@song)
    click_on "Destroy this song", match: :first

    assert_text "Song was successfully destroyed"
  end
end
