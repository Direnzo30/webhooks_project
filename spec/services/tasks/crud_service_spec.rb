# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::CrudService do
  subject(:crud_service) { described_class }

  describe '#index' do
    let!(:project1) { create(:project) }
    let!(:project2) { create(:project) }
    let!(:task1) { create(:task, project: project1) }
    let!(:task2) { create(:task, project: project2) }
    let!(:task3) { create(:task, project: project1) }

    it 'returns the tasks related to an especific project' do
      expect(crud_service.index(project1)).to match_array([task1, task3])
    end
  end

  describe '#create' do
    let!(:project) { create(:project) }

    context 'when task params are valid' do
      let!(:task_params) do
        {
          name: 'Awesome task',
          description: 'Awesome description'
        }
      end

      it 'creates the task and return it' do
        task = crud_service.create(project, task_params)
        expect(Task.order(id: :asc).last).to eq(task)
      end
    end

    context 'when task params are invalid' do
      let!(:task_params) do
        {
          name: '',
          description: 'But name is mandatory'
        }
      end

      it 'raises an invalid record exception' do
        expect { crud_service.create(project, task_params) }.to raise_error(InvalidRecordException)
      end
    end
  end

  describe '#update' do
    let!(:task) { create(:task) }

    context 'when task params are valid' do
      let!(:task_params) do
        {
          name: 'The new name',
          description: 'The new description'
        }
      end

      it 'updates the task and return it' do
        expect(crud_service.update(task, task_params)).to have_attributes(task_params)
      end
    end

    context 'when task params are invalid' do
      let!(:task_params) do
        {
          name: '',
          description: 'missing name'
        }
      end

      it 'raises an invalid record exception' do
        expect { crud_service.update(task, task_params) }.to raise_error(InvalidRecordException)
      end
    end
  end

  describe '#destroy' do
    let!(:task) { create(:task) }

    it 'destroy the record' do
      expect do
        crud_service.destroy(task)
      end.to change(Task, :count).by(-1)
    end
  end
end
