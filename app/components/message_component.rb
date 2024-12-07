# frozen_string_literal: true

class MessageComponent < ApplicationComponent
  option :message

  delegate :markdown, to: :helpers

  def class_names
    if message.role == "user"
      "bg-blue-100 text-gray-800 p-4 rounded-lg mb-4 ml-auto max-w-6xl"
    else
      "bg-gray-100 text-gray-800 p-4 rounded-lg mb-4 mr-auto max-w-6xl"
    end
  end
end
