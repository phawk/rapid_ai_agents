class AgentsController < ApplicationController
  def show
    @agent = Ai::Agent.find_by!(name: params[:id])

    @task = Ai::AgentTask.create!(
      agent: @agent,
      user: Current.user,
      team: Current.user.team
    )
  end

  def create
    task = Ai::AgentTask.find(params[:task_id])

    user_message = task.messages.create!(
      role: "user",
      content: params[:message]
    )

    task.agent.run!(task)

    render turbo_stream: turbo_stream.replace(
      "message-form",
      partial: "agents/form",
      locals: { task: task }
    )
  end
end
