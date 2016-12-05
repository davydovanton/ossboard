module Admin::Views::Users
  class Index
    include Admin::View

    def users_active?
      true
    end
  end
end
