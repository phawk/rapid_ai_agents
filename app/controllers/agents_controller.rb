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

    response = task.agent.run!(task)

    assistant_message = task.messages.create!(
      role: response[:role],
      content: response[:content]
    )

    render turbo_stream: [
      turbo_stream.append(
        "messages",
        html: MessageComponent.new(message: user_message).render_in(view_context)
      ),
      turbo_stream.append(
        "messages",
        html: MessageComponent.new(message: assistant_message).render_in(view_context)
      ),
      turbo_stream.replace("message-form", partial: "agents/form", locals: { task: task })
    ]
  end
end
