# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'GET #index' do
    let!(:project1) { create(:project) }
    let!(:project2) { create(:project) }
    let!(:task1) { create(:task, project: project1) }
    let!(:task2) { create(:task, project: project2) }
    let(:expected_response) do
      {
        data: [{
          id: task1.id.to_s,
          type: 'task',
          attributes: {
            name: task1.name,
            description: task1.description,
            project_id: project1.id,
            created_at: task1.created_at.as_json,
            updated_at: task1.updated_at.as_json
          }
        }]
      }
    end

    it 'returns all tasks for project' do
      authenticated_get route: project_tasks_path(project_id: project1.id)

      expect(response).to be_ok
      expect(json_response).to eq(expected_response)
    end
  end

  describe 'POST #create' do
    let(:project) { create(:project) }
    let(:task) { Task.order(id: :desc).first }

    context 'when successfully created' do
      let(:params) do
        { name: 'Test Name', description: 'Test Desc' }
      end
      let(:expected_response) do
        {
          data: {
            id: task.id.to_s,
            type: 'task',
            attributes: {
              name: 'Test Name',
              description: 'Test Desc',
              project_id: project.id,
              created_at: Time.zone.now.as_json,
              updated_at: Time.zone.now.as_json
            }
          }
        }
      end

      it 'returns task json' do
        freeze_time do
          authenticated_post route: project_tasks_path(project_id: project.id), params: params

          expect(response).to be_ok
          expect(json_response).to eq(expected_response)
        end
      end
    end

    context 'when error occurred' do
      it 'returns errors' do
        authenticated_post route: project_tasks_path(project_id: project.id), params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to eq(
          errors: ["Name can't be blank", "Description can't be blank"].to_s
        )
      end
    end
  end

  describe 'GET #show' do
    context 'when task exists' do
      let(:task) { create(:task) }
      let(:expected_response) do
        {
          data: {
            id: task.id.to_s,
            type: 'task',
            attributes: {
              name: task.name,
              description: task.description,
              project_id: task.project_id,
              created_at: task.created_at.as_json,
              updated_at: task.updated_at.as_json
            }
          }
        }
      end

      it 'when returns task json' do
        authenticated_get route: project_task_path(project_id: task.project_id, id: task.id)

        expect(response).to be_ok
        expect(json_response).to eq(expected_response)
      end
    end

    context 'when task does not exist' do
      let!(:project) { create(:project) }

      it 'returns 404' do
        authenticated_get route: project_task_path(project_id: project.id, id: 1)

        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'when task does not exist for project' do
      let!(:project1) { create(:project) }
      let!(:project2) { create(:project) }
      let!(:task1) { create(:task, project: project1) }
      let!(:task2) { create(:task, project: project2) }

      it 'returns 404' do
        authenticated_get route: project_task_path(project_id: project1.id, id: task2.id)

        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end

  describe 'PATCH #update' do
    context 'when task exists' do
      let(:task) { create(:task) }

      context 'when successfully updated' do
        let(:params) do
          {
            name: 'Random Test Name'
          }
        end
        let(:expected_response) do
          {
            data: {
              id: task.id.to_s,
              type: 'task',
              attributes: {
                name: 'Random Test Name',
                description: task.description,
                project_id: task.project_id,
                created_at: task.created_at.as_json,
                updated_at: Time.zone.now.as_json
              }
            }
          }
        end

        it 'returns task json' do
          freeze_time do
            authenticated_patch route: project_task_path(project_id: task.project_id, id: task.id), params: params

            expect(response).to be_ok
            expect(json_response).to eq(expected_response)
          end
        end
      end

      context 'when error occurred' do
        let(:params) do
          {
            name: ''
          }
        end

        it 'returns errors' do
          authenticated_patch route: project_task_path(project_id: task.project_id, id: task.id), params: params

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response).to eq(errors: ["Name can't be blank"].to_s)
        end
      end
    end

    context 'when task does not exist' do
      let!(:project) { create(:project) }
      let(:params) do
        {
          name: 'Test'
        }
      end

      it 'returns 404' do
        authenticated_patch route: project_task_path(project_id: project.id, id: 1), params: params

        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'when task does not exist for organization' do
      let!(:project1) { create(:project) }
      let!(:project2) { create(:project) }
      let!(:task1) { create(:task, project: project1) }
      let!(:task2) { create(:task, project: project2) }
      let(:params) do
        {
          name: 'Test'
        }
      end

      it 'returns 404' do
        authenticated_patch route: project_task_path(project_id: project1.id, id: task2.id), params: params

        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when task exists' do
      let(:task) { create(:task) }

      it 'returns 200' do
        authenticated_delete route: project_task_path(project_id: task.project_id, id: task.id)
        expect(response).to be_ok
      end
    end

    context 'when task does not exist' do
      let!(:project) { create(:project) }

      it 'returns 404' do
        authenticated_delete route: project_task_path(project_id: project.id, id: 1)

        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'when task does not exist for project' do
      let!(:project1) { create(:project) }
      let!(:project2) { create(:project) }
      let!(:task1) { create(:task, project: project1) }
      let!(:task2) { create(:task, project: project2) }

      it 'returns 404' do
        authenticated_delete route: project_task_path(project_id: project1.id, id: task2.id)

        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end
end
