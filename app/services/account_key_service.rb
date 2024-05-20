require 'net/http'
require 'json'

class AccountKeyService
  ACCOUNT_KEY_SERVICE_URL = 'https://w7nbdj3b3nsy3uycjqd7bmuplq0yejgw.lambda-url.us-east-2.on.aws/v1/account'.freeze

  def self.generate_account_key(email, key)
    uri = URI(ACCOUNT_KEY_SERVICE_URL)
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = { email: email, key: key }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)['account_key']
    else
      raise "Failed to fetch account key: #{response.body}"
    end
  end
end
