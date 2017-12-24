class Task < Hanami::Entity
  attributes do
    attribute :id,                Types::Int
    attribute :count,             Types::Int
    attribute :user_id,           Types::String
    attribute :body,              Types::String
    attribute :title,             Types::String
    attribute :lang,              Types::String
    attribute :md_body,           Types::String
    attribute :issue_url,         Types::String
    attribute :status,            Types::String
    attribute :complexity,        Types::String
    attribute :repository_name,   Types::String
    attribute :time_estimate,     Types::String
    attribute :assignee_username, Types::String
    attribute :approved,          Types::Bool
    attribute :first_pr,          Types::Bool
    attribute :created_at,        Types::Time
    attribute :updated_at,        Types::Time
    attribute :created_at_day,    Types::Date
  end

  VALID_STATUSES = {
    in_progress: 'in progress',
    assigned: 'assigned',
    closed: 'closed',
    done: 'done',
    moderation: 'moderation',
  }.freeze

  VALID_LANGUAGES = {
    unknown: 'unknown',
    ruby: 'ruby',
    javascript: 'javascript',
    typescript: 'typescript',
    java: 'java',
    python: 'python',
    go: 'go',
    csharp: 'csharp',
    fsharp: 'fsharp',
    vbnet: 'vbnet',
    c: 'c',
    cplusplus: 'cplusplus',
    haskell: 'haskell',
    lua: 'lua',
    scala: 'scala',
    elixir: 'elixir',
    rust: 'rust',
    clojure: 'clojure',
    php: 'php',
    crystal: 'crystal'
  }.freeze

  def author
    UserRepository.new.find(user_id)
  end
end
