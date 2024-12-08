# frozen_string_literal: true

class MessageComponent < ApplicationComponent
  option :message

  delegate :markdown, to: :helpers
  delegate :content, to: :message
  delegate :role, to: :message

  def class_names
    if message.role == "user"
      "bg-blue-100 text-gray-800 p-4 rounded-lg mb-4 ml-auto max-w-6xl"
    else
      "bg-gray-100 text-gray-800 p-4 rounded-lg mb-4 mr-auto max-w-6xl"
    end
  end

  def tool_call?
    content.blank? && message.tool_calls.present?
  end

  def tool_result?
    content.present? && message.tool_call_id.present? && role == "tool"
  end

  def tool_call_name
    name = message.tool_calls.first.dig("function", "name")
    id = message.tool_calls.first.dig("id")

    "#{name}# - #{id}"
  end

  def tool_result_name
    message.tool_call_id
  end
end
