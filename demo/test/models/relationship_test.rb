require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(personA_id: people(:michael).id,
                                     personB_id: people(:archer).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a personA_id" do
    @relationship.personA_id = nil
    assert_not @relationship.valid?
  end

  test "should require a personB_id" do
    @relationship.personB_id = nil
    assert_not @relationship.valid?
  end
end
