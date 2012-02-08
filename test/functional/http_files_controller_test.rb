require 'test_helper'

class HttpFilesControllerTest < ActionController::TestCase
  setup do
    @http_file = http_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:http_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create http_file" do
    assert_difference('HttpFile.count') do
      post :create, :http_file => @http_file.attributes
    end

    assert_redirected_to http_file_path(assigns(:http_file))
  end

  test "should show http_file" do
    get :show, :id => @http_file.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @http_file.to_param
    assert_response :success
  end

  test "should update http_file" do
    put :update, :id => @http_file.to_param, :http_file => @http_file.attributes
    assert_redirected_to http_file_path(assigns(:http_file))
  end

  test "should destroy http_file" do
    assert_difference('HttpFile.count', -1) do
      delete :destroy, :id => @http_file.to_param
    end

    assert_redirected_to http_files_path
  end
end
