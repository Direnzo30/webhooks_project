# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  describe 'GET #index' do
    let!(:organization1) { create(:organization) }
    let!(:organization2) { create(:organization) }
    let!(:project1) { create(:project, organization: organization1) }
    let!(:project2) { create(:project, organization: organization2) }
    let(:expected_response) do
      {
        data: [{
          id: project1.id.to_s,
          type: 'project',
          attributes: {
            name: project1.name,
            organization_id: organization1.id,
            created_at: project1.created_at.as_json,
            updated_at: project1.updated_at.as_json
          }
        }]
      }
    end

    it 'returns all projects for organization' do
      authenticated_get route: organization_projects_path(organization_id: organization1.id)

      expect(response).to be_ok
      expect(json_response).to eq(expected_response)
    end
  end

  describe 'POST #create' do
    let(:organization) { create(:organization) }
    let(:project) { Project.order(id: :desc).first }
    let(:expected_response) do
      {
        data: {
          id: project.id.to_s,
          type: 'project',
          attributes: {
            name: 'Test Name',
            organization_id: organization.id,
            created_at: Time.zone.now.as_json,
            updated_at: Time.zone.now.as_json
          }
        }
      }
    end

    context 'when successfully created' do
      it 'returns project json' do
        freeze_time do
          authenticated_post route: organization_projects_path(organization_id: organization.id),
                             params: { name: 'Test Name' }

          expect(response).to have_http_status(:ok)
          expect(json_response).to eq(expected_response)
        end
      end
    end

    context 'when error occurred' do
      it 'returns errors' do
        authenticated_post route: organization_projects_path(organization_id: organization.id)

        expect(response.status).to eq(422)
        expect(json_response).to eq(errors: ["Name can't be blank"].to_s)
      end
    end
  end

  describe 'GET #show' do
    context 'when project exists' do
      let(:project) { create(:project) }
      let(:expected_response) do
        {
          data: {
            id: project.id.to_s,
            type: 'project',
            attributes: {
              name: project.name,
              organization_id: project.organization_id,
              created_at: project.created_at.as_json,
              updated_at: project.updated_at.as_json
            }
          }
        }
      end

      it 'returns project json' do
        authenticated_get route: organization_project_path(organization_id: project.organization_id, id: project.id)

        expect(response).to be_ok
        expect(json_response).to eq(expected_response)
      end
    end

    context 'when project does not exist' do
      let!(:organization) { create(:organization) }

      it 'returns 404' do
        authenticated_get route: organization_project_path(organization_id: organization.id, id: 1)

        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'when project does not exist for organization' do
      let!(:organization1) { create(:organization) }
      let!(:organization2) { create(:organization) }
      let!(:project1) { create(:project, organization: organization1) }
      let!(:project2) { create(:project, organization: organization2) }

      it 'returns 404' do
        authenticated_get route: organization_project_path(organization_id: organization1.id, id: project2.id)

        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end

  describe 'PATCH #update' do
    context 'when project exists' do
      let(:project) { create(:project) }

      context 'when successfully updated' do
        let(:params) do
          {
            name: 'Random Test Name'
          }
        end
        let(:expected_response) do
          {
            data: {
              id: project.id.to_s,
              type: 'project',
              attributes: {
                name: 'Random Test Name',
                organization_id: project.organization_id,
                created_at: project.created_at.as_json,
                updated_at: Time.zone.now.as_json
              }
            }
          }
        end

        it 'returns project json' do
          freeze_time do
            authenticated_patch route: organization_project_path(organization_id: project.organization_id,
                                                                 id: project.id),
                                params: params

            expect(response).to be_ok
            expect(json_response).to eq(expected_response)
          end
        end
      end

      context 'when error occurred' do
        it 'returns errors' do
          authenticated_patch route: organization_project_path(organization_id: project.organization_id,
                                                               id: project.id),
                              params: { name: '' }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response).to eq(errors: ["Name can't be blank"].to_s)
        end
      end
    end

    context 'when project does not exist' do
      let!(:organization) { create(:organization) }

      it 'returns 404' do
        authenticated_patch route: organization_project_path(organization_id: organization.id, id: 1),
                            params: { name: 'Test' }

        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'when project does not exist for organization' do
      let!(:organization1) { create(:organization) }
      let!(:organization2) { create(:organization) }
      let!(:project1) { create(:project, organization: organization1) }
      let!(:project2) { create(:project, organization: organization2) }

      it 'returns 404' do
        authenticated_patch route: organization_project_path(organization_id: organization1.id, id: project2.id),
                            params: { name: 'Test' }

        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when project exists' do
      let(:project) { create(:project) }

      it 'returns 200' do
        authenticated_delete route: organization_project_path(organization_id: project.organization_id, id: project.id)
        expect(response).to be_ok
      end
    end

    context 'when project does not exist' do
      let!(:organization) { create(:organization) }

      it 'returns 404' do
        authenticated_delete route: organization_project_path(organization_id: organization.id, id: 1)

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'when project does not exist for organization' do
      let!(:organization1) { create(:organization) }
      let!(:organization2) { create(:organization) }
      let!(:project1) { create(:project, organization: organization1) }
      let!(:project2) { create(:project, organization: organization2) }

      it 'returns 404' do
        authenticated_delete route: organization_project_path(organization_id: organization1.id, id: project2.id)

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end
end
