require "rails_helper"

RSpec.describe Ai::AgentMessage, type: :model do
  it { is_expected.to belong_to(:agent_task).class_name("Ai::AgentTask") }
end
