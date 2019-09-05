# frozen_string_literal: true

RSpec.shared_context :web_mocked do
  let(:default_headers) { { 'Accept': 'application/json',
                            'Content-Type': 'application/json'} }

  before :all do
    WebMock.enable!
  end

  after :all do
    WebMock.disable!
  end
end

RSpec.configure do |rspec|
  rspec.include_context :web_mocked, :web_mocked
end
