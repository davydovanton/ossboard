module Web::Controllers::Tasks
  class Index
    include Web::Action
    include Hanami::Pagination::Action
    expose :tasks

    def call(params)
      relation = TaskRepository.new.search_relation(search_params)
      @tasks = all_for_page(relation)
    end

  private

    # TODO: replace to service object
    def search_params
      for_moderation? ?
        with_language(user_id: current_user.id, approved: nil) :
        with_language(status: status, approved: true)
    end

    def for_moderation?
      params[:status] == 'moderation' && authenticated?
    end

    def with_language(search_params)
      search_params[:repository_name] = params[:repository] if params[:repository]
      search_params[:lang] = params[:lang] if Task::VALID_LANGUAGES.values.include?(params[:lang])
      search_params
    end

    def status
      Task::VALID_STATUSES.values.include?(params[:status]) ? params[:status] : 'in progress'
    end

    def limit
      50
    end
  end
end
