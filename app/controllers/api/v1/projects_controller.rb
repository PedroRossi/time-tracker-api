class Api::V1::ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy]
  
  # 3) api/v1/projects -----------------> View all projects as organization and project owner. [Every http method except create as it needs user id]
  # 4) api/v1/users/:user_id/projects -------------> User views his projects, create a project as organization manager [Index, Create, Destroy]
  # GET /projects
  def index
    if params[:user_id]
      @projects = User.find(params[:user_id]).projects
    else
      @projects = Project.all
    end
    render json: @projects
  end 

  # GET /projects/1
  def show
    render json: @project
  end

  # POST /projects
  def create
    @user = User.find(params[:user_id])
    if !@user.isOwner
      render json: {status: :unauthorized} and return
    end

    @project = Project.new(project_params)
    if @project.save 
      @relation = ProjectUser.new(user_id: params[:user_id], project_id: @project.id, owner: true)
      if @relation.save
        render json: @project, status: :created
      else
        @project.destroy
        render json: {status: :unprocessable_entity}
      end
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    @user = User.find(params[:user_id])
    if !@user.isOwner
      render json: {status: :unauthorized} and return
    end
    
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @user = User.find(params[:user_id])
    if !@user.isOwner
      render json: {status: :unauthorized} and return
    end

    ProjectUser.where(project_id: params[:id]).destroy_all
    @project.destroy
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
