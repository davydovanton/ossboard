module Web::Controllers::Tasks
  class CreateParams < Web::Action::Params
    params do
      required(:task).schema do
        required(:title).filled(:str?)
        required(:description).filled(:str?)
        required(:lang).filled(:str?)
        required(:complexity).filled(:str?)
        required(:time_estimate).filled(:str?)
        required(:user_id).filled
        optional(:issue_url).maybe(:str?)
        optional(:repository_name).maybe(:str?)
      end
    end
  end
end
