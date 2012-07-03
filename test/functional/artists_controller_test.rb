require 'test_helper'

class ArtistsControllerTest < ActionController::TestCase
  setup do
    @artist = artists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:artists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create artist" do
    assert_difference('Artist.count') do
      post :create, :artist => { :activity => @artist.activity, :database_activity => @artist.database_activity, :name => @artist.name, :obtained => @artist.obtained, :reference => @artist.reference }
    end

    assert_redirected_to artist_path(assigns(:artist))
  end

  test "should show artist" do
    get :show, :id => @artist
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @artist
    assert_response :success
  end

  test "should update artist" do
    put :update, :id => @artist, :artist => { :activity => @artist.activity, :database_activity => @artist.database_activity, :name => @artist.name, :obtained => @artist.obtained, :reference => @artist.reference }
    assert_redirected_to artist_path(assigns(:artist))
  end

  test "should destroy artist" do
    assert_difference('Artist.count', -1) do
      delete :destroy, :id => @artist
    end

    assert_redirected_to artists_path
  end
end
