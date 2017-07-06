module Web::Controllers::Tasks
  class Update
    include Web::Action

    expose :task

    params do
      required(:id).filled

      required(:task).schema do
        required(:title).filled(:str?)
        required(:md_body).filled(:str?)
        required(:lang).filled(:str?)
        required(:user_id).filled
        optional(:issue_url).maybe(:str?)
        optional(:repository_name).maybe(:str?)
      end
    end

    def call(params)
      @task = repo.find(params[:id])

      check_edit_ability

      if params.valid?
        repo.update(@task.id, task_params(params))

        flash[:info] = 'Task had been updated.'
        redirect_to routes.task_path(@task.id)
      else
        self.body = Web::Views::Tasks::Edit.render(format: format, task: @task, current_user: current_user, params: params)
      end
    end

  private

    def check_edit_ability
      return if current_user.can_edit_task?(task)
      flash[:error] = "You doesn't have access for editing this task"
      redirect_to routes.task_path(@task.id)
    end

    def repo
      @repo ||= TaskRepository.new
    end

    def task_params(params)
      task_params = params[:task]
      task_params[:body] = Container[:markdown].call(task_params[:md_body])
      task_params
    end
  end
end
