# frozen_string_literal: true

module JsonHelpers
  def json_response
    unless @body.eql? response.body
      @body = response.body
      @json_response = nil
    end
    @json_response ||= JSON.parse @body
  end
end
