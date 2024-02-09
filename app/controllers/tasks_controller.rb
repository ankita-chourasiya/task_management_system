class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_task, only: [:update, :destroy]

  def index
    @tasks = Task.all
    render json: @tasks
  end

  def create
    if Task.too_many_todo_tasks?(params[:status])
      render_error("Too many tasks in To Do status", :unprocessable_entity)
    else
      @task = Task.new(task_params)
      if @task.save
        render json: @task, status: :created
      else
        render_error(@task.errors.full_messages, :unprocessable_entity)
      end
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render_error(@task.errors.full_messages, :unprocessable_entity)
    end
  end

  def destroy
    @task.destroy
    render json: {message: "sucessfully deleted"}
  end

  private

  def set_task
    @task = Task.find_by(id: params[:id])
    render_error("Task not found", :not_found) unless @task
  end

  def task_params
    params.permit(:title, :description, :status)
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
