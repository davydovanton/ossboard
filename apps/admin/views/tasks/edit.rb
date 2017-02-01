module Admin::Views::Tasks
  class Edit
    include Admin::View

    def form
      form_for task_form, id: 'task-form', class: 'task-form pure-form pure-form-stacked' do
        div class: 'task-form__fields' do
          div class: 'input task-form__field pure-control-group' do
            label      :title, for: 'title'
            text_field :title, value: task.title
          end

          div class: 'input task-form__field pure-control-group' do
            label      :repository_name
            text_field :repository_name, value: task.repository_name
          end

          div class: 'input task-form__field pure-control-group' do
            label      :assignee_username
            text_field :assignee_username, value: task.assignee_username
          end

          div class: 'input task-form__field pure-control-group' do
            label      :issue_url
            text_field :issue_url, value: task.issue_url
          end

          div class: 'input' do
            label  :complexity
            select :complexity, complexity_options_list
          end

          div class: 'input' do
            label  :time_estimate
            select :time_estimate, time_estimate_options_list
          end

          div class: 'input task-form__field pure-control-group' do
            label     :description
            text_area :description, task.description
          end

          div class: 'input task-form__field pure-control-group' do
            label     :approved
            check_box :approved, checked: checkbox_status
          end

          div class: 'input task-form__field' do
            select :lang, langs_list
          end

          div class: 'input task-form__field pure-control-group' do
            select :status, { 'in progress' => 'in progress', 'assigned' => 'assigned', 'done' => 'done', 'closed' => 'closed' }, options: {selected: task.status}
          end
        end

        div class: 'task-form__actions pure-controls' do
          a 'back', href: routes.task_path(task.id), class: 'pure-button'
          submit 'Update', class: 'pure-button pure-button-primary'
        end
      end
    end

    def task_form
      Form.new(:task, routes.task_path(task.id),
        { task: task }, { method: :patch })
    end

    def params
      {}
    end

    def checkbox_status
      task.approved ? 'checked' : nil
    end

    def tasks_active?
      true
    end
  end
end
