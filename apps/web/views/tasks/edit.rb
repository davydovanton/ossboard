module Web::Views::Tasks
  class Edit
    include Web::View

    def title
      'OSSBoard: edit task'
    end

    def form
      form_for task_form, id: 'task-form', class: 'task-form pure-form' do
        hidden_field :user_id, value: current_user.id

        div class: 'input' do
          text_field :title, value: task.title, placeholder: 'Title'
        end

        div class: 'input' do
          text_field :issue_url, value: task.issue_url, placeholder: 'Link to issue (optional)'
        end

        div class: 'input' do
          text_area :description, task.description, placeholder: 'Description'
          div(class: 'task-form__description-tip') do
            em '* you can use markdown syntax'
          end
        end

        div class: 'input' do
          select :lang, langs_list
        end

        if current_user.registred?
          div class: 'input agree-checkbox' do
            check_box :aprove, id: 'agreement-chackbox'
            label 'I agree to be a mentor to the developer that’s willing to work on my project’s task'
          end
        end

        a 'Back', href: routes.tasks_path, class: 'btn btn-back'

        if current_user.registred?
          submit('Create', class: 'pure-button pure-button-disabled pure-button-primary', id: 'new-task-submit')
        else
          span('Create', class: 'pure-button pure-button-disabled')
        end
      end
    end

    def task_form
      Form.new(:task, routes.task_path(task.id), {}, { method: :patch })
    end

    def tasks_active?
      true
    end
  end
end
