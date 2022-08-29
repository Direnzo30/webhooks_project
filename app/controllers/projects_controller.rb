# frozen_string_literal: true

# Exposes API for interacting with Projects.
class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_organization
  before_action :find_project, only: %i[show update destroy]

  def index
    @projects = Projects::CrudService.index(@organization)
    render_response(@projects, ProjectSerializer)
  end

  def create
    @project = Projects::CrudService.create(@organization, project_params)
    render_response(@project, ProjectSerializer)
  end

  def show
    render_response(@project, ProjectSerializer)
  end

  def update
    @project = Projects::CrudService.update(@project, project_params)
    render_response(@project, ProjectSerializer)
  end

  def destroy
    Projects::CrudService.destroy(@project)
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
