# frozen_string_literal: true

module Tasks
  # Service for handling the crud operations of a task
  class CrudService
    def self.index(project)
      project.tasks
    end

    def self.create(project, task_params)
      task = project.tasks.build(task_params)
      raise(InvalidRecordException, task.errors.full_messages) unless task.save

      task
    end

    def self.update(task, task_params)
      raise(InvalidRecordException, task.errors.full_messages) unless task.update(task_params)

      task
    end

    def self.destroy(task)
      raise(InvalidRecordException, task.errors.full_messages) unless task.destroy
    end
  end
end
