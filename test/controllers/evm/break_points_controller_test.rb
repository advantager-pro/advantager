require 'test_helper'

class EVM::BreakPointsControllerTest < ActionController::TestCase
  setup do
    @evm_break_point = evm_break_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evm_break_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evm_break_point" do
    assert_difference('EVM::BreakPoint.count') do
      post :create, evm_break_point: { actual_cost: @evm_break_point.actual_cost, day: @evm_break_point.day, earned_value: @evm_break_point.earned_value, planned_value: @evm_break_point.planned_value, project_id: @evm_break_point.project_id }
    end

    assert_redirected_to evm_break_point_path(assigns(:evm_break_point))
  end

  test "should show evm_break_point" do
    get :show, id: @evm_break_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @evm_break_point
    assert_response :success
  end

  test "should update evm_break_point" do
    patch :update, id: @evm_break_point, evm_break_point: { actual_cost: @evm_break_point.actual_cost, day: @evm_break_point.day, earned_value: @evm_break_point.earned_value, planned_value: @evm_break_point.planned_value, project_id: @evm_break_point.project_id }
    assert_redirected_to evm_break_point_path(assigns(:evm_break_point))
  end

  test "should destroy evm_break_point" do
    assert_difference('EVM::BreakPoint.count', -1) do
      delete :destroy, id: @evm_break_point
    end

    assert_redirected_to evm_break_points_path
  end
end
