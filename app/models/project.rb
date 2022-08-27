# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id              :bigint           not null, primary key
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#
# Indexes
#
#  index_projects_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_9aee26923d  (organization_id => organizations.id)
#
class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :organization

  validates :name, presence: true
end
