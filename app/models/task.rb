class Task < ApplicationRecord

  belongs_to :user_to, foreign_key: 'user_to_id', class_name: 'AdminUser'
  belongs_to :project

  scope :with_user_from, -> (user) { where(user_from: user) }
  scope :with_user_to, -> (user) { where(user_to: user) }

  validates :page, presence: true, uniqueness: true

  def self.flatten_hash(user_tasks, flatten_user_tasks = [])
    user_tasks.each do |x|
      if x[:child].class.eql?(Array)
        flatten_hash(x[:child], flatten_user_tasks)
        x.delete(:child)
        flatten_user_tasks.push(x)
      else
        flatten_user_tasks.push(x)
      end
    end
    flatten_user_tasks
  end

  def self.clean_params(params)
    clean_params = params.except!(:user_from, :date_added, :priority,
                                  :date_closed, :date_end, :tags,
                                  :date_start, :company, :max_money, :max_time)
    clean_params[:user_to] = AdminUser.where(email: clean_params[:user_to][:email])
                                 .first_or_create(email: clean_params[:user_to][:email], password: 'password')
    clean_params
  end

  def self.build_tasks_for_current(user)
    organization_id = Rails.application.credentials[:production][:organization][:id]
    habstaff_client = HubstaffClient.new
    habstaff_projects = habstaff_client.organization_projects(user.access_token, organization_id).deep_symbolize_keys[:projects]
    habstaff_tasks = habstaff_client.organization_tasks(user.access_token, organization_id).deep_symbolize_keys[:tasks]
    active_hb_tasks = habstaff_tasks.reduce([]){|sum, i| i[:status].eql?('active') ? sum.push(i) : sum }
    client = Worksection::Client.new(Rails.application.credentials.production[:worksection][:domain_name],
                                     Rails.application.credentials.production[:worksection][:worksection_key])
    ws_tasks = client.get_all_tasks({show_subtasks: 1}).deep_symbolize_keys[:data]
    ws_tasks = flatten_hash(ws_tasks)
    #
    #
    active_ws_tasks = ws_tasks.reduce([]) do |sum, i|
      i[:status].eql?('active') && i[:user_to][:email].eql?(user.email) ? sum.push(i) : sum
    end
    sync_tasks = active_hb_tasks.reduce([]){|sum, i| active_ws_tasks.select{ |x| x[:name].eql?(i[:summary])}.count > 0 ? sum.push(active_ws_tasks.select{ |x| x[:name].eql?(i[:summary])}) : sum}.flatten
    unsync_tasks = active_ws_tasks - sync_tasks
    ws_projects = client.get_projects.deep_symbolize_keys[:data]
    grouped_by_projects = unsync_tasks.group_by{|x| x[:page].scan(/(\/project\/\d+\/)/).flatten[0]}
    project_for_user_by_ws = ws_projects.select{|x| grouped_by_projects.keys.include? x[:page]}
    sync_projects = habstaff_projects.reduce([]){|sum, i| project_for_user_by_ws.select{ |x| x[:name].eql?(i[:name])}.count > 0 ? sum.push(habstaff_projects.select{ |x| x[:name].eql?(i[:name])}) : sum}.flatten
    unsync_projects = project_for_user_by_ws - sync_projects
    unsync_projects.map{|i| habstaff_client.organization_project_create(user.access_token, organization_id, i[:name], [user])}

=begin
    projects = client.get_projects.deep_symbolize_keys[:data]

    grouped_tasks = user_tasks.group_by{|x| x[:page].scan(/(\/project\/\d+\/)/).flatten[0]}

    selected_projects = projects.select{|x| x[:page][/#{grouped_tasks.keys}/]}
    selected_projects.map do |s_p|
      project_clean_params = clean_params(s_p)
      project_ = Project.where(page: project_clean_params[:page]).first_or_create
      project_.update_attributes(project_clean_params)
      project_.tasks << grouped_tasks[project_.page].map do |single_task|
        clean_params = clean_params(single_task).merge(project: project_)
        task = Task.where(page: single_task[:page]).first_or_create
        task.update(clean_params)
        task
      end
    end
=end
  end
end
