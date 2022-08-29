# frozen_string_literal: true

# Exposes API for interacting with Organizations.
class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_organization

  def show
    render_response(@organization, OrganizationSerializer)
  end

  private

  def find_organization
    @organization = Organization.find(params[:id])
  end
end
