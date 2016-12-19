require "dry-matcher"

GITHUB_ISSUE_REGEXP = %r[github\.com/(\w+)/(\w+)/issues/(\d+)].freeze

success_case = Dry::Matcher::Case.new(
  match:   -> value, *pattern { pattern.include?(:github) && value.match(GITHUB_ISSUE_REGEXP) },
  resolve: -> value do
    match = value.match(GITHUB_ISSUE_REGEXP)
    { org: match[1], repo: match[2], issue: match[3] }
  end
)

failure_case = Dry::Matcher::Case.new(
  match: -> value { true },
  resolve: -> value { { error: 'invalid url' } }
)

GitHostMatcher = Dry::Matcher.new(success: success_case, failure: failure_case)
