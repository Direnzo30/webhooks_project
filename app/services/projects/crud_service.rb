# frozen_string_literal: true

module Projects
  # Service for handling the crud operations of a project
  class CrudService
    #
    # Index functionality for projects
    #
    # @param [Organization] organization - The organization that contains the projects
    #
    # @return [Project[]] The projects associated to the organization
    #
    def self.index(organization)
      organization.projects
    end

    #
    # Create functionality for a project
    #
    # @param [Organization] organization - The parent organization for the project
    # @param [Hash] project_params - The attributes for creating the project
    #
    # @return [Project] The created project
    #
    def self.create(organization, project_params)
      project = organization.projects.build(project_params)
      raise(InvalidRecordException, project.errors.full_messages) unless project.save

      project
    end

    #
    # Update functionality for a project
    #
    # @param [Project] project - The project to be updated
    # @param [Hash] project_params - The attributes for updating the project
    #
    # @return [Project] The updated project
    #
    def self.update(project, project_params)
      raise(InvalidRecordException, project.errors.full_messages) unless project.update(project_params)

      project
    end

    #
    # Destroy functionality for a project
    #
    # @param [Project] project - The project to be deleted
    #
    # @return [nil]
    #
    def self.destroy(project)
      raise(InvalidRecordException, project.errors.full_messages) unless project.destroy
    end
  end
end
