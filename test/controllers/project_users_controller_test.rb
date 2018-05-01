require 'test_helper'

class ProjectUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_user = project_users(:one)
  end

  test "should get index" do
    get project_users_url, as: :json
    assert_response :success
  end

  test "should create project_user" do
    assert_difference('ProjectUser.count') do
      post project_users_url, params: { project_user: { owner: @project_user.owner, project_id: @project_user.project_id, user_id: @project_user.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show project_user" do
    get project_user_url(@project_user), as: :json
    assert_response :success
  end

  test "should update project_user" do
    patch project_user_url(@project_user), params: { project_user: { owner: @project_user.owner, project_id: @project_user.project_id, user_id: @project_user.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy project_user" do
    assert_difference('ProjectUser.count', -1) do
      delete project_user_url(@project_user), as: :json
    end

    assert_response 204
  end
end
