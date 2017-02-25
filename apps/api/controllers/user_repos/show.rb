module Api::Controllers::UserRepos
  class Show
    include Api::Action

    params do
      required(:login).filled(:str?)
    end

    def call(params)
      require 'pry'; binding.pry
      if params.valid?
        self.body = repos_page
      else
        self.status = 404
        self.body = '[]'
      end
    end

    private

    def repos_page
      body = []
      page = 1
      loop do
        response = get_repos(page)
        break if response == '[]'
        repos.push(response)
        page += 1
      end
      return repos.join
    end

    def get_repos(page)
      HttpRequest.new("https://api.github.com/users/#{params[:login]}/repos?per_page=100&page=#{page}").get.body
    end
  end
end
