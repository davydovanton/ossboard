module Admin::Views::Users
  class Index
    include Admin::View

    def users
      UserRepository.new.all
    end

    def link_to_user(user)
      link_to user.name, routes.user_path(user.id)
    end

    def users_active?
      true
    end

    def user_role(user)
      user.admin ? 'admin' : 'user'
    end
  end
end
