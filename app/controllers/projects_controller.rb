class ProjectsController < ApplicationController
  before_action :find_organization
  before_action :find_project, only: %i[show update destroy]

  def index
    render json: ProjectSerializer.new(@organization.projects).serialized_json
  end

  def create
    @project = @organization.projects.build(project_params)

    if @project.save
      render json: ProjectSerializer.new(@project).serialized_json
    else
      render json: {errors: @project.errors.full_messages}, status: 422
    end
  end

  def show
    render json: ProjectSerializer.new(@project).serialized_json
  end

  def update
    if @project.update(project_params)
      render json: ProjectSerializer.new(@project).serialized_json
    else
      render json: {errors: @project.errors.full_messages}, status: 422
    end
  end

  def destroy
    @project.destroy
    head :ok
  end

  private

  def find_organization
    @organization = Organization.find(params[:organization_id])
  end

  def find_project
    @project = @organization.projects.find(params[:id])
  end

  def project_params
    params.permit(:name)
  end
end
