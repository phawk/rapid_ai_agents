class Ai::Tools::DateTimeTool < Ai::Tools::BaseTool
  define_function :get_current_datetime, description: "Get the current date and time in various formats" do
    property :format, type: "string", description: "The format to return the date/time in (iso8601, rfc2822, or default)", required: false
  end

  def get_current_datetime(format: "default")
    start_timer!

    current_time = Time.current
    formatted_time = case format&.downcase
                    when "iso8601"
                      current_time.iso8601
                    when "rfc2822"
                      current_time.rfc2822
                    else
                      current_time.to_s
                    end

    json_response({
      datetime: formatted_time,
      timestamp: current_time.to_i,
      timezone: Time.zone.name
    })
  end
end
