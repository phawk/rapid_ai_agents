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
      tools: tools
    )

    task.messages.ordered.each do |message|
      assistant.add_message(
        role: message.role,
        content: message.content
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

  def available_tools
    {
      web_search: Langchain::Tool::Tavily.new(api_key: ENV.fetch("TAVILY_API_KEY"))
    }
  end
end
