module Admin::Controllers::Users
  class Show
    include Admin::Action
    expose :user

    def call(params)
      @user = UserRepository.new.find(params[:id])
    end
  end
end
