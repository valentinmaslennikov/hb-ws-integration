# frozen_string_literal: true

RSpec.shared_context :mailer do
  let!(:mailer) { double 'ApplicationMailer', deliver_now!: true }
end

RSpec.configure do |rspec|
  rspec.include_context :mailer, :mailer
end
