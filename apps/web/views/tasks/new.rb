module Web::Views::Tasks
  class New
    include Web::View

    def form
      form_for task_form, id: 'task-form', class: 'task-form pure-form' do
        hidden_field :user_id, value: current_user.id

        div class: 'input' do
          text_field :title, value: task.title, placeholder: 'Title'
        end

        div class: 'input' do
          text_area :md_body, value: task.md_body, placeholder: 'Body'
          div(class: 'task-form__body-tip') do
            em '* you can use markdown syntax'
          end
        end

        div class: 'input' do
          select :lang, { 'language' => 'undefined', 'ruby' => 'ruby', 'js' => 'js' }
        end

        a 'Back', href: routes.tasks_path, class: 'btn btn-back'

        if current_user.id
          submit('Create', class: 'pure-button pure-button-primary')
        else
          span('Create', class: 'pure-button pure-button-disabled')
        end
      end
    end

    def task_form
      Form.new(:task, routes.tasks_path, {}, { method: :post })
    end

    def tasks_active?
      true
    end
  end
end
