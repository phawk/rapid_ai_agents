require "rails_helper"

RSpec.describe Ai::AgentTask, type: :model do
  it { is_expected.to belong_to(:agent).class_name("Ai::Agent") }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:parent_task).class_name("Ai::AgentTask").optional }
  it { is_expected.to have_many(:messages).class_name("Ai::AgentMessage").dependent(:destroy) }
end
