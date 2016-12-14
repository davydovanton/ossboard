module Admin::Controllers::Tasks
  class Show
    include Admin::Action
    expose :task, :author

    def call(params)
      @task = TaskRepository.new.find(params[:id])
      @author = UserRepository.new.find(@task.user_id) || User.new(name: 'Anonymous')
    end
  end
end
