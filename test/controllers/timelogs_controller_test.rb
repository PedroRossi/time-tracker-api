require 'test_helper'

class TimelogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @timelog = timelogs(:one)
  end

  test "should get index" do
    get timelogs_url, as: :json
    assert_response :success
  end

  test "should create timelog" do
    assert_difference('Timelog.count') do
      post timelogs_url, params: { timelog: { description: @timelog.description, time: @timelog.time } }, as: :json
    end

    assert_response 201
  end

  test "should show timelog" do
    get timelog_url(@timelog), as: :json
    assert_response :success
  end

  test "should update timelog" do
    patch timelog_url(@timelog), params: { timelog: { description: @timelog.description, time: @timelog.time } }, as: :json
    assert_response 200
  end

  test "should destroy timelog" do
    assert_difference('Timelog.count', -1) do
      delete timelog_url(@timelog), as: :json
    end

    assert_response 204
  end
end
