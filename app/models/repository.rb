class Repository < ApplicationRecord
  has_many :events, foreign_key: :repo_full_name, primary_key: :full_name
  validates :full_name, uniqueness: true
end