class Ai::Agent < ApplicationRecord
  has_many :tasks, class_name: "Ai::AgentTask", dependent: :destroy

  before_validation do
    self.tools = [] if tools.blank?
  end

  normalizes :tools, with: -> (value) {
    value.is_a?(String) ? JSON.parse(value) : value
  }

  def run!(task)
    assistant = Langchain::Assistant.new(
      llm: llm,
      instructions: instructions,
      tools: tools.map { |tool| available_tools(task:)[tool.to_sym] }.compact,
      add_message_callback: -> (message) {
        # Rails.logger.info("agent:#{name} message callback: #{message.role} - #{message.content}")
        task.upsert_message(
          role: message.role,
          content: message.content&.dup&.force_encoding("UTF-8"),
          tool_calls: message.tool_calls,
          tool_call_id: message.tool_call_id
        )
      }
    )

    task.messages.ordered.each do |message|
      assistant.add_message(
        role: message.role,
        content: message.content,
        tool_calls: message.tool_calls.presence || [],
        tool_call_id: message.tool_call_id
      )
    end

    assistant.run(auto_tool_execution: true)

    last_message = assistant.messages.last

    {
      role: last_message.role,
      content: last_message.content
    }
  end

  private

  def llm
    @llm ||= Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"], default_options: { chat_model: "gpt-4o" })
  end

  def available_tools(task:)
    {
      web_search: Langchain::Tool::Tavily.new(api_key: ENV.fetch("TAVILY_API_KEY")),
      date_time: Ai::Tools::DateTimeTool.new(task:)
    }
  end
end
