require 'test_helper'

class PcodesControllerTest < ActionController::TestCase
  setup do
    @pcode = pcodes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pcodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pcode" do
    assert_difference('Pcode.count') do
      post :create, :pcode => @pcode.attributes
    end

    assert_redirected_to pcode_path(assigns(:pcode))
  end

  test "should show pcode" do
    get :show, :id => @pcode.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @pcode.to_param
    assert_response :success
  end

  test "should update pcode" do
    put :update, :id => @pcode.to_param, :pcode => @pcode.attributes
    assert_redirected_to pcode_path(assigns(:pcode))
  end

  test "should destroy pcode" do
    assert_difference('Pcode.count', -1) do
      delete :destroy, :id => @pcode.to_param
    end

    assert_redirected_to pcodes_path
  end
end
