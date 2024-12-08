class Ai::RunTaskJob < ApplicationJob
  queue_as :default

  def perform(task)
    task.agent.run!(task)
  end
end
