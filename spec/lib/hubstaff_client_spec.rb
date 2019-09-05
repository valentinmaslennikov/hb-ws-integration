# frozen_string_literal: true

describe HubstaffClient, type: :lib do
  let(:instance) { described_class.new }

  describe '#task_create', :web_mocked do
    let(:assignee_id)   { rand.to_s }
    let(:project_id)    { rand.to_s }
    let(:title)         { rand.to_s }
    let(:access_token)  { rand.to_s }
    let(:response_body) { { sample: rand.to_s } }

    before do
      stub_request(:post, "https://api.hubstaff.com/v2/projects/#{project_id}/tasks").
          with(body: {
              summary: title,
              assignee_id: assignee_id
          }.to_json,
               headers: {
                   'Content-Type' => 'application/json',
                   Accept: 'application/json',
                   Authorization: "Bearer #{access_token}"
               }).
          to_return(status: 200,
                    body: response_body.to_json,
                    headers: default_headers)
    end

    subject { instance.task_create access_token, project_id, title, assignee_id }

    it 'Main case' do
      is_expected.to be_a HTTParty::Response
      is_expected.to have_attributes parsed_response: response_body.stringify_keys
    end
  end

  describe '#task_update' do
    it 'Main case'
  end

  describe '#task_delete' do
    it 'Main case'
  end

  describe '#organization_tasks' do
    it 'Main case'
  end

  describe '#organization_projects' do
    it 'Main case'
  end

  describe '#organization_project_create' do
    it 'Main case'
  end

  describe '#organization_members' do
    it 'Main case'
  end

  describe '#organization_user' do
    it 'Main case'
  end

  describe '#organization_activities' do
    it 'Main case'
  end

  describe '#access_token_request' do
    it 'Main case'
  end

  describe '#refresh_access_token_request' do
    it 'Main case'
  end
end
