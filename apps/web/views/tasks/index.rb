module Web::Views::Tasks
  class Index
    include Web::View

    def title
      'OSSBoard: tasks'
    end

    def link_to_task(task)
      link_to task.title, routes.task_path(id: task.id)
    end

    def link_to_new_task
      link_to 'POST A TASK', routes.new_task_path, class: 'link'
    end

    def task_statuses
      {
        'in progress' => 'Open',
        'assigned' => 'Assigned',
        'closed' => 'Closed',
        'done' => 'Finished'
      }
    end

    def task_languages
      Hanami::Utils::Hash.new(
        { 'any' => 'language' }.merge!(Task::VALID_LANGUAGES)
      ).stringify!
    end

    def tasks_status
      params[:status] || 'in progress'
    end

    def tasks_language
      params[:lang] || 'any'
    end

    def tasks_active?
      true
    end

    def complexity_label(task)
      html.span(class: "level level-#{task.complexity}") { text(task.complexity.upcase) }
    end

    def first_pr_label(task)
      return unless task.first_pr
      html.span(class: "first-pr") { text('first PR') }
    end

    def select_tasks_by_status
      html.select(id: "task-status-select", '@change': "changeStatus($event)") do
        task_statuses.each { |status, text| option(text, value: status, selected: status == tasks_status) }
        option('On moderation', value: "moderation", selected: tasks_status == 'moderation') if current_user.registred?
      end
    end

    def select_tasks_by_language
      html.select(id: "task-language-select", '@change': "changeLang($event)") do
        task_languages.each do |languge, text|
          option(text, value: languge, selected: languge == tasks_language)
        end
      end
    end

    def author_information(author, task)
      html.div(class: 'task-item__author') do
        text('Posted by')
        a(href: routes.user_path(author.login)) do
          img class: 'task-item__author-avatar', src: author.avatar_url
          text(author.name || author.login)
        end
        text(RelativeTime.in_words(task.created_at))
        text(" • #{task.lang}")
      end
    end
  end
end
