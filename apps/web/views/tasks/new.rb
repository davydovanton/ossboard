module Web::Views::Tasks
  class New
    include Web::View

    def title
      'OSSBoard: new task'
    end

    def form
      form_for task_form, id: 'task-form', class: 'task-form pure-form' do
        input type: "hidden", name: "_csrf_token", value: updated_csrf_token if updated_csrf_token
        hidden_field :user_id, value: current_user.id

        div class: 'input' do
          label :title
          text_field :title, value: task.title
        end

        div class: 'input' do
          label :repository_name do
            text 'Repository name'
            span '- optional', class: 'optional'
          end
          text_field :repository_name, value: task.repository_name
        end

        div class: 'input' do
          label :issue_url do
            text 'Link to issue'
            span '- optional', class: 'optional'
          end
          text_field :issue_url, value: task.issue_url
        end

        div class: 'select-blocks' do
          div class: 'input' do
            label :complexity
            select :complexity, complexity_options_list
          end

          div class: 'input' do
            label :time_estimate
            select :time_estimate, time_estimate_options_list
          end

          div class: 'input' do
            label(:lang) { text('Task language') }
            select :lang, Task::VALID_LANGUAGES
          end
        end

        div class: 'input task-body', id: "task-body" do
          div class: 'pure-u-1 task-body__write', 'v-if' => "write" do
            div(class: 'task-body__title') do
              label(:md_body) { text 'Description' }
              button 'Preview', type: :button, 'v-on:click' => 'displayPreview', class: 'btn btn-default pure-menu-link'
            end

            text_area :md_body, task.md_body, 'v-model' => "taskBody"
            div(class: 'task-form__body-tip') do
              em '* you can use markdown syntax'
            end
          end

          div class: 'pure-u-1 task-body__preview', 'v-if' => "preview" do
            div(class: 'task-body__title') do
              label(:md_body) { text 'Description' }
              button 'Write', type: :button, 'v-on:click' => 'displayForm', class: 'btn btn-default pure-menu-link'
            end

            div id: "floatingCirclesG", 'v-if' => "loadPreview" do
              div class: "f_circleG", id: "frotateG_01"
              div class: "f_circleG", id: "frotateG_02"
              div class: "f_circleG", id: "frotateG_03"
              div class: "f_circleG", id: "frotateG_04"
              div class: "f_circleG", id: "frotateG_05"
              div class: "f_circleG", id: "frotateG_06"
              div class: "f_circleG", id: "frotateG_07"
              div class: "f_circleG", id: "frotateG_08"
            end

            text_area :md_body, style: "display:none;", 'v-model' => "taskBody"
            div class: 'task-body__preview', id: 'previewed-text', 'v-html' => "rawBody" do
            end
          end
        end

        if current_user.registred?
          div class: 'input first-pr-checkbox' do
            check_box :first_pr, id: 'first-pr-checkbox'
            label 'This task good for first PR', for: 'first-pr-checkbox', class: 'first-pr-label'
          end

          div class: 'input agree-checkbox' do
            check_box :aprove, id: 'agreement-checkbox'
            label 'I agree to be a mentor to the developer that’s willing to work on my project’s task', for: 'agreement-checkbox', class: 'agreement-label'
          end
        end

        div(class: 'task-form__actions') do
          a 'Back', href: routes.tasks_path, class: 'link link-back'

          if current_user.registred?
            submit('Create', class: 'button button-disabled', id: 'new-task-submit')
          else
            span('Create', class: 'button button-disabled')
          end
        end
      end
    end

    def validation_errors
      params.error_messages.map { |e| e.sub(MD_BODY_REGEXP, 'Body'.freeze) }
    end

    def task_form
      Form.new(:task, routes.tasks_path, {}, { method: :post })
    end

    def tasks_active?
      true
    end

  private

    MD_BODY_REGEXP = /Md Body/
  end
end
