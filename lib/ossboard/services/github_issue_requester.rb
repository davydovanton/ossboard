require "net/https"

class GithubIssueRequester
  def self.call(params)
    new.call(params)
  end

  def call(params)
    response = get_response(GITHUB_API_URL % params)
    data = JSON.parse(response.body)

    if response.is_a?(Net::HTTPSuccess)
      { html_url: data['html_url'], title: data['title'], body: data['body'] }
    else
      { error: 'invalid url' }
    end
  end

  private

  GITHUB_API_URL = 'https://api.github.com/repos/%{org}/%{repo}/issues/%{issue}'.freeze

  def get_response(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    http.request(request)
  end
end
