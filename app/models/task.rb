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
    client = Worksection::Client.new(Rails.application.credentials.production[:worksection][:domain_name],
                                     Rails.application.credentials.production[:worksection][:worksection_key])
    user_tasks = client.get_all_tasks({show_subtasks: 1}).deep_symbolize_keys[:data]
    user_tasks = flatten_hash(user_tasks)
    #
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
=begin
    user_tasks.select { |x| x[:user_to][:email].eql?(current_admin_user.email) }
        .reduce([]) do |sum, x|
      x[:user_to] = current_admin_user
      x.except!(:user_from, :date_added, :priority, :date_closed, :date_end, :tags, :date_start)
      sum.push(x)
    end
    user_tasks.map { |u_p| Task.where(page: u_p[:page]).first_or_create do |task|
      task.update_attributes(u_p)
    end
    }
=end
  end
end
