# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Projects::CrudService do
  subject(:crud_service) { described_class }

  describe '#index' do
    let!(:organization1) { create(:organization) }
    let!(:organization2) { create(:organization) }
    let!(:project1) { create(:project, organization: organization1) }
    let!(:project2) { create(:project, organization: organization2) }
    let!(:project3) { create(:project, organization: organization1) }

    it 'returns the projects related to an especific organization' do
      expect(crud_service.index(organization1)).to match_array([project1, project3])
    end
  end

  describe '#create' do
    let!(:organization) { create(:organization) }

    context 'when project params are valid' do
      let!(:project_params) do
        {
          name: 'Awesome project'
        }
      end

      it 'creates the project and return it' do
        project = crud_service.create(organization, project_params)
        expect(Project.order(id: :asc).last).to eq(project)
      end
    end

    context 'when project params are invalid' do
      let!(:project_params) do
        {
          name: ''
        }
      end

      it 'raises an invalid record exception' do
        expect { crud_service.create(organization, project_params) }.to raise_error(InvalidRecordException)
      end
    end
  end

  describe '#update' do
    let!(:project) { create(:project) }

    context 'when project params are valid' do
      let!(:project_params) do
        {
          name: 'The new name'
        }
      end

      it 'updates the project and return it' do
        expect(crud_service.update(project, project_params)).to have_attributes(project_params)
      end
    end

    context 'when project params are invalid' do
      let!(:project_params) do
        {
          name: ''
        }
      end

      it 'raises an invalid record exception' do
        expect { crud_service.update(project, project_params) }.to raise_error(InvalidRecordException)
      end
    end
  end

  describe '#destroy' do
    let!(:project) { create(:project) }
    let!(:tasks_size) { 4 }
    let!(:tasks) { create_list(:task, tasks_size, project: project) }

    it 'destroy the record and it\'s dependencies' do
      expect do
        crud_service.destroy(project)
      end.to change(Project, :count).by(-1).and change(Task, :count).by(-tasks_size)
    end
  end
end
