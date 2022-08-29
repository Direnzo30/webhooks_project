# frozen_string_literal: true

# Exposes API for interacting with Tasks.
class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project
  before_action :find_task, only: %i[show update destroy]

  def index
    @tasks = Tasks::CrudService.index(@project)
    render_response(@tasks, TaskSerializer)
  end

  def create
    @task = Tasks::CrudService.create(@project, task_params)
    render_response(@task, TaskSerializer)
  end

  def show
    render_response(@task, TaskSerializer)
  end

  def update
    @task = Tasks::CrudService.update(@task, task_params)
    render_response(@task, TaskSerializer)
  end

  def destroy
    Tasks::CrudService.destroy(@task)
    head :ok
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.permit(:name, :description)
  end
end
