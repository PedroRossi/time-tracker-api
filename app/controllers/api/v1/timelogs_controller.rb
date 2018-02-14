class Api::V1::TimelogsController < ApplicationController
  before_action :authenticate_request! #Token is allright?
  before_action :checkAccepted #Is the user requesting this accepted?
  before_action :checkOwner, only: [:show]
  before_action :set_timelog, only: [:show, :update, :destroy]
  before action :isTimelogOwner, only: [:show, :update, :destroy]
 
  def isTimelogOwner
    if !@timelog.user_id == @current_user.id
      render status: :unauthorized and return 
  end

  # GET /timelogs
  # /timelogs?initialDate=20-01-2018&finalDate=24-01-2018
  def index
    if params[:initialDate] && params[:finalDate]
      @timelogs = Timelog.by_date(params[:initialDate, params[:finalDate])
    else
      @timelogs = Timelog.all
    render json: @timelogs
  end

  # GET /timelogs/1
  def show
    render json: @timelog
  end

  # POST /timelogs
  def create
    @timelog = Timelog.new(description: params[:timelog][:description], time: params[:timelog][:time], project_id: params[:project_id], user_id: @current_user.id)

    if @timelog.save
      render json: @timelog, status: :created
    else
      render json: @timelog, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /timelogs/1
  def update
    if @timelog.update(timelog_params)
      render json: @timelog
    else
      render json: @timelog.errors, status: :unprocessable_entity
    end
  end

  # DELETE /timelogs/1
  def destroy
    @timelog.destroy
  end

  def pending
    @timelog = Timelog.where(finished: false, user_id: params[:user_id])
    render json: @timelog
  end

  #get /user/projects/:project_id/timelogs
  def show_current_user_timelogs
    @timelogs = @current_user.timelogs.where(project_id: params[:project_id]).by_date(params[:initialDate], params[:finalDate]).order('created_at DESC')
    render json: @timelogs
  end

  #get /projects/:project_id/timelogs
  def show_project_timelogs
    if ProjectUser.where(project_id: params[:project_id]).user_id != @current_user.id
      render json: status: :unauthorized and return

    @timelogs = Timelog.where(project_id: params[:project_id]).by_date(params[:initialDate], params[:finalDate]).order('created_at DESC')
    render json: @timelogs
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timelog
      @timelog = Timelog.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def timelog_params
      params.require(:timelog).permit(:description, :time, :finished)
    end
end
