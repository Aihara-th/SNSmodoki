class Relationship < ApplicationRecord
  belongs_to :personA, class_name: "Person", foreign_key: "personA_id"
  belongs_to :personB, class_name: "Person", foreign_key: "personB_id"
  validates :personA_id, presence: true
  validates :personB_id, presence: true
end
