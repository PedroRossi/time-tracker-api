class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_request!
  before_action :checkAccepted #Is the user requesting this accepted?
  before_action :checkIsOnProject, only: [:show] #Check if user requesting is on project
  before_action :checkOwner, only: [:index, :create] #Is this user a owner?
  before_action only: [:update, :destroy] do
    isProjectOwner(params[:id]) 
  end
  before_action :set_project, only: [:show, :update, :destroy]
  
  def checkIsOnProject
    if !@current_user.isOwner && !ProjectUser.where(user_id: @current_user.id, project_id: params[:id]).exists?
        render json: {error: "User is not in the project."}, status: :unauthorized and return
    end
  end
  
  # GET /projects
  def index
    @projects = Project.all
    render json: @projects
  end 
  
  # GET /projects/1
  def show
    render json: @project
  end

  # POST /projects
  def create
    @user = User.find(params[:user_id])

    @project = Project.new(project_params)
    if @project.save 
      @relation = ProjectUser.new(user_id: params[:user_id], project_id: @project.id, owner: true)
      if @relation.save
        render json: @project, status: :created
      else
        @project.destroy
        render json: @relation.errors, status: :unprocessable_entity
      end
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    ProjectUser.where(project_id: params[:id]).destroy_all
    @project.destroy
  end

  def show_current_user_projects
    @projects = @current_user.projects
    render json: @projects
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :description)
    end
end
