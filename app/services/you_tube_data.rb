class YouTubeData
  
  require 'google/api_client'

  attr_accessor :client

  #class variables
  #@client
  #@results

  def initialize
    @client = Google::APIClient.new

    # authenticating
    key = Google::APIClient::PKCS12.load_key("#{Rails.root}/config/youtube-data-directory-3f8a2c8370be.p12", 'notasecret')
    @client.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => 'https://www.googleapis.com/auth/youtube',
      :issuer => '292859569291-43l7cnd1lr2jo5s3rl84gqk8sah5j05l@developer.gserviceaccount.com',
      :signing_key => key
      )
    @client.authorization.fetch_access_token!
  end

  def get_data_by_category_id(categoryId)
    result = @client.execute(
      :api_method => @client.discovered_api('youtube', 'v3').channels.list,
      :parameters => { part: 'statistics', categoryId: categoryId}
    )

    if result.success?
      # @results = JSON.parse result.response.body
      # @nextPageToken = result["nextPageToken"]
      # add_results_to_database(@results, categoryId)
      # 10.times do
      #   next_api_call(@client, categoryId)
      # end
      ap JSON.parse result.response.body
    end
  end

  private
  def next_api_call(client, categoryId)
    result = client.execute(
      :api_method => client.discovered_api('youtube', 'v3').channels.list,
      :parameters => { part: 'statistics', categoryId: categoryId, nextPageToken: @nextPageToken}
    )
    
    if result.success?
      @results = JSON.parse result.response.body
      binding.pry
      @nextPageToken = @results["nextPageToken"]
      add_results_to_database(@results, categoryId)
      puts @results

    end
  end
  
  def add_results_to_database(results, category_id)
    results["items"].each do |you_tube_channel|
      my_channel = Channel.new
      my_channel.channel_id = you_tube_channel["id"]
      my_channel.view_count = you_tube_channel["statistics"]["viewCount"]
      my_channel.comment_count = you_tube_channel["statistics"]["commentCount"]
      my_channel.subscriber_count = you_tube_channel["statistics"]["subscriberCount"]
      my_channel.hidden_subscriber_count = you_tube_channel["statistics"]["hiddenSubscriberCount"]
      my_channel.video_count = you_tube_channel["statistics"]["videoCount"]
      my_channel.category_id = category_id
      my_channel.save
    end
  end


#NOTES: On API Usage
# get categoryId here with part=snippet, region=US
# https://developers.google.com/youtube/v3/docs/guideCategories/list

# go here to get list of channels given a category id (GCQ29tZWR5 - comedy) / part = statistics
# https://developers.google.com/youtube/v3/docs/channels/list
 # result = client.execute(:api_method => client.discovered_api('youtube', 'v3').channels.list, :parameters => { part: 'statistics', categoryId: categoryId, nextPageToken: "CAUQAA"})



end
