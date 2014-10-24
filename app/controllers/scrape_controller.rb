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

  private

  def initialize_google_client
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

    return client
  end

  def initial_api_call(client, categoryId)

    result = client.execute(
      :api_method => client.discovered_api('youtube', 'v3').channels.list,
      :parameters => { part: 'statistics', categoryId: categoryId}
    )

    if result.success?
        logger result.data
        return JSON.parse result.response.body
    end

  end

  def next_api_call(client, categoryId, nextPageToken)
    result = client.execute(
      :api_method => client.discovered_api('youtube', 'v3').channels.list,
      :parameters => { part: 'statistics', categoryId: categoryId, nextPageToken: nextPageToken}
    )

    if result.success?
        logger result.data
        return JSON.parse result.response.body
    end
  end
  
  def add_results_to_database(results)
    binding.pry
    results["items"].each do |you_tube_channel|
      my_channel = Channel.new
      my_channel.id = you_tube_channel["id"]
      my_channel.view_count = you_tube_channel["viewCount"]
      my_channel.comment_count = you_tube_channel["commentCount"]
      my_channel.subscriber_count = you_tube_channel["subscriberCount"]
      my_channel.hidden_subscriber_count = you_tube_channel["hiddenSubscriberCount"]
      my_channel.video_count = you_tube_channel["videoCount"]
      my_channel.category_id = "GCQ29tZWR5"
      my_channel.save
    end
  end




end
# get categoryId here with part=snippet, region=US
# https://developers.google.com/youtube/v3/docs/guideCategories/list

# go here to get list of channels given a category id (GCQ29tZWR5 - comedy) / part = statistics
# https://developers.google.com/youtube/v3/docs/channels/list