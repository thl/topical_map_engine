require_relative '../test_helper'

class TranslatedTitlesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:translated_titles)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_translated_title
    assert_difference('TranslatedTitle.count') do
      post :create, :translated_title => { }
    end

    assert_redirected_to translated_title_path(assigns(:translated_title))
  end

  def test_should_show_translated_title
    get :show, :id => translated_titles(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => translated_titles(:one).id
    assert_response :success
  end

  def test_should_update_translated_title
    put :update, :id => translated_titles(:one).id, :translated_title => { }
    assert_redirected_to translated_title_path(assigns(:translated_title))
  end

  def test_should_destroy_translated_title
    assert_difference('TranslatedTitle.count', -1) do
      delete :destroy, :id => translated_titles(:one).id
    end

    assert_redirected_to translated_titles_path
  end
end
