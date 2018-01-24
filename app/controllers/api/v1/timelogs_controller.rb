class Api::V1::TimelogsController < ApplicationController
  before_action :set_timelog, only: [:show, :update, :destroy]

  
  # 2) api/v1/timelogs -----------------> View all timelogs as organization owner. [Every http method, except create as it needs a project and a user.]
  # 6) api/v1/users/:user_id/projects/:project_id/timelogs ----> See timelogs from a user in a project, user creates a timelog (maybe temporary) [Index, Update, Create, Destroy]
  # 5) api/v1/projects/:project_id/timelogs ---------> Project owner sees everybody's timelogs from a project [Index]
  
  # GET /timelogs
  # /timelogs?initialDate=20-01-2018&finalDate=24-01-2018

  def index
    if params[:user_id]
      if params[:initialDate] && params[:finalDate]
        @timelogs = User.find(params[:user_id]).timelogs.by_date(params[:initialDate], params[:finalDate]).order('created_at DESC')
      else
        @timelogs = User.find(params[:user_id]).timelogs.where(project_id: params[:project_id])
      end
    elsif params[:project_id]
      if params[:initialDate] && params[:finalDate]
        @timelogs = Project.find(params[:project_id]).timelogs.by_date(params[:initialDate], params[:finalDate]).order('created_at DESC')
      else
        @timelogs = Project.find(params[:project_id]).timelogs
      end  
    else
      if params[:initialDate] && params[:finalDate]
        @timelogs = Timelog.by_date(params[:initialDate], params[:finalDate]).order('created_at DESC')
      else
        @timelogs = Timelog.all
      end
    end
    render json: @timelogs
  end

  # GET /timelogs/1
  def show
    render json: @timelog
  end

  # POST /timelogs
  def create
    @timelog = Timelog.new(description: params[:timelog][:description], time: params[:timelog][:time], project_id: params[:project_id], user_id: params[:user_id])
    
    if @timelog.save
      render json: @timelog, status: :created
    else
      render json: @timelog, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /timelogs/1
  def update
    if @timelog.user_id == params[:user_id].to_i
      if @timelog.update(timelog_params)
        render json: @timelog
      else
        render json: @timelog.errors, status: :unprocessable_entity
      end
    else
      render json: {status: @timelog.user_id, status2: params[:user_id]}
    end
  end

  # DELETE /timelogs/1
  def destroy
    if @timelog.user_id == params[:user_id].to_i
      @timelog.destroy
    else
      render json: {status: :unauthorized}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timelog
      @timelog = Timelog.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def timelog_params
      params.require(:timelog).permit(:description, :time) 
    end
end
