# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  has_secure_password
end