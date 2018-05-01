require 'test_helper'

class UserTimelogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_timelog = user_timelogs(:one)
  end

  test "should get index" do
    get user_timelogs_url, as: :json
    assert_response :success
  end

  test "should create user_timelog" do
    assert_difference('UserTimelog.count') do
      post user_timelogs_url, params: { user_timelog: { report_id: @user_timelog.report_id, user_id: @user_timelog.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show user_timelog" do
    get user_timelog_url(@user_timelog), as: :json
    assert_response :success
  end

  test "should update user_timelog" do
    patch user_timelog_url(@user_timelog), params: { user_timelog: { report_id: @user_timelog.report_id, user_id: @user_timelog.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy user_timelog" do
    assert_difference('UserTimelog.count', -1) do
      delete user_timelog_url(@user_timelog), as: :json
    end

    assert_response 204
  end
end
