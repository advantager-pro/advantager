require 'test_helper'

class Advantager::EVM::PointsControllerTest < ActionController::TestCase
  setup do
    @evm_point = evm_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evm_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evm_point" do
    assert_difference('Advantager::EVM::Point.count') do
      post :create, evm_point: { actual_cost: @evm_point.actual_cost, day: @evm_point.day, earned_value: @evm_point.earned_value, issue_id: @evm_point.issue_id, planned_value: @evm_point.planned_value }
    end

    assert_redirected_to evm_point_path(assigns(:evm_point))
  end

  test "should show evm_point" do
    get :show, id: @evm_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @evm_point
    assert_response :success
  end

  test "should update evm_point" do
    patch :update, id: @evm_point, evm_point: { actual_cost: @evm_point.actual_cost, day: @evm_point.day, earned_value: @evm_point.earned_value, issue_id: @evm_point.issue_id, planned_value: @evm_point.planned_value }
    assert_redirected_to evm_point_path(assigns(:evm_point))
  end

  test "should destroy evm_point" do
    assert_difference('Advantager::EVM::Point.count', -1) do
      delete :destroy, id: @evm_point
    end

    assert_redirected_to evm_points_path
  end
end
