# frozen_string_literal: true

module Projects
  # Service for handling the crud operations of a project
  class CrudService
    def self.index(organization)
      organization.projects
    end

    def self.create(organization, project_params)
      project = organization.projects.build(project_params)
      raise(InvalidRecordException, project.errors.full_messages) unless project.save

      project
    end

    def self.update(project, project_params)
      raise(InvalidRecordException, project.errors.full_messages) unless project.update(project_params)

      project
    end

    def self.destroy(project)
      raise(InvalidRecordException, project.errors.full_messages) unless project.destroy
    end
  end
end
