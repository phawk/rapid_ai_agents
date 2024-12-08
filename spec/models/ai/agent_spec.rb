require "rails_helper"

RSpec.describe Ai::Agent, type: :model do
  it { is_expected.to have_many(:tasks).class_name("Ai::AgentTask").dependent(:destroy) }
end
