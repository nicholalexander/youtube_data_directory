class ScrapeController < ApplicationController

  def index
    # creating client instance
    require 'google/api_client'
    
    client = Google::APIClient.new

    # authenticating
    key = Google::APIClient::PKCS12.load_key("#{Rails.root}/config/youtube-data-directory-3f8a2c8370be.p12", 'notasecret')
    client.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => 'https://www.googleapis.com/auth/youtube',
      :issuer => '292859569291-43l7cnd1lr2jo5s3rl84gqk8sah5j05l@developer.gserviceaccount.com',
      :signing_key => key
      )
    client.authorization.fetch_access_token!

    
    # API call
    # NOTE: Check the documentation for API methods and parameters). The method discovered_api returns a service object. We can use to_h.keys to get the list of available keys of that object. Keys represents API methods (e.g. "analytics.management.accounts.list" the API method path is "management.accounts.list").

    
    result = client.execute(
      :api_method => client.discovered_api('youtube', 'v3').channels.list,
      :parameters => { part: 'statistics', categoryId: 'GCQ29tZWR5'}
    )
    if result.success?
        result.data
        @view_result = JSON.parse result.response.body
    end
  
    # add_results_to_database(JSON.parse result.response.body)

  end 
end