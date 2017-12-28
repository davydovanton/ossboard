module Web::Views::Tasks
  class Index
    include Web::View
    include Hanami::Pagination::View

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

    def pagination
      html.div(class: 'pagination') do

       if pager.prev_page.nil?
         span(class: 'disabled previous_page')
           text '← Previous'
       else
         a(href: page_url(pager.prev_page) + '&status=' + params[:status]) do
           text '← Previous'
         end
       end

       total_pages = pager.all_pages.count

       first_in_range = pager.pages_range.first

       if 1 < first_in_range
         a(href: page_url(1) + '&status=' + params[:status]) do
           1
         end
       end

       if 2 < first_in_range
         a(href: page_url(2) + '&status=' + params[:status]) do
           2
         end
       end

       if 1 < first_in_range || 2 < first_in_range
         span(class: 'gap') do
           text '...'
         end
       end

       pager.pages_range.each do |page_number|

        if pager.current_page?(page_number)
          em(class: 'current') do
            text page_number
          end
         else
           a(href: page_url(page_number) + '&status=' + params[:status]) do
             page_number
           end
        end

       end

       last_in_range =  pager.pages_range[-1]

       if last_in_range < total_pages
         span(class: 'gap') do
           text '...'
         end

         if last_in_range != total_pages-1
           a(href: page_url(total_pages-1) + '&status=' + params[:status]) do
             total_pages-1
           end
         end

         a(href: page_url(total_pages) + '&status=' + params[:status]) do
           total_pages
         end

       end

       if pager.next_page.nil?
         span(class: 'disabled next_page')
         text 'Next →'
       else
         a(href: page_url(pager.next_page) + '&status=' + params[:status]) do
           text 'Next →'
         end
       end

      end
    end

  end
end
