module Web::Controllers::Tasks
  class Create
    include Web::Action
    include Import['tasks.interactors.create']

    expose :task

    params do
      required(:task).schema do
        required(:title).filled(:str?)
        required(:md_body).filled(:str?)
        required(:lang).filled(:str?)
        required(:complexity).filled(:str?)
        required(:time_estimate).filled(:str?)
        required(:user_id).filled
        optional(:issue_url).maybe(:str?)
        optional(:repository_name).maybe(:str?)
        optional(:first_pr).filled(:bool?)
      end
    end

    def call(params)
			return unless authenticated?
      result = create.new(params.valid?, params).call

      if result.successful?
        flash[:info] = INFO_MESSAGE
        redirect_to routes.tasks_path
      else
        self.body = Web::Views::Tasks::New.render(format: format, task: result.task,
          current_user: current_user, params: params, updated_csrf_token: set_csrf_token)
      end
    end

    private

    INFO_MESSAGE = 'Task had been added to moderation. You can check your task status on profile page'.freeze
  end
end
