module Web::Views::Leaderboards
  class Index
    include Web::View

    def users
      UserRepository.new.all.last(15)
    end

    # TODO: Tests
    def user_information(user)
      html.div(class: 'user-row__name') do
        a(href: routes.user_path(user.login)) do
          img class: 'user-row__avatar', src: user.avatar_url
          text(user.login)
        end
      end
    end
  end
end
