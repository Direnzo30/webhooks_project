# frozen_string_literal: true

module Tasks
  # Service for handling the crud operations of a task
  class CrudService
    #
    # Index functionality for tasks
    #
    # @param [Project] project - The project that contains the tasks
    #
    # @return [Task[]] The tasks associated to the project
    #
    def self.index(project)
      project.tasks
    end

    #
    # Create functionality for a task
    #
    # @param [Project] project - The parent project for the task
    # @param [Hash] task_params - The attributes for creating the task
    #
    # @return [Project] The created project
    #
    def self.create(project, task_params)
      task = project.tasks.build(task_params)
      raise(InvalidRecordException, task.errors.full_messages) unless task.save

      task
    end

    #
    # Update functionality for a task
    #
    # @param [Task] task - The task to be updated
    # @param [Hash] task_params - The attributes for updating the task
    #
    # @return [Task] The updated project
    #
    def self.update(task, task_params)
      raise(InvalidRecordException, task.errors.full_messages) unless task.update(task_params)

      task
    end

    #
    # Destroy functionality for a task
    #
    # @param [Task] task - The task to be deleted
    #
    # @return [nil]
    #
    def self.destroy(task)
      raise(InvalidRecordException, task.errors.full_messages) unless task.destroy
    end
  end
end
