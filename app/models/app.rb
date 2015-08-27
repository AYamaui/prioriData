class App

  include HTTParty

  # Fetches the top rated apps inside the category
  def self.fetch_top_rated_apps(category_id, monetization)
    response = HTTParty.get(
                "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop", 
                query: {genreId: "#{category_id}", 
                        popId: "30", 
                        dataOnly: "true", 
                        l: "en"}, 
                headers: {"Accept-Encoding" => "gzip, deflate, sdch", 
                          "Accept-Language" => "en-US,en;q=0.8,lv;q=0.6", 
                          "User-Agent" => 
                            "iTunes/11.1.1 (Windows; Microsoft Windows 7 \
                              x64 Ultimate Edition Service Pack 1 (Build 7601))\
                               AppleWebKit/536.30.1", 
                          "Accept" => "text/html,application/xhtml+xml,\
                                        application/xml;q=0.9,\
                                        image/webp,*/*;q=0.8", 
                          "Cache-Control" => "max-age=0", 
                          "X-Apple-Store-Front" => "143441-1,17"})

    return [] unless response.success? && response["topCharts"]

    response = JSON.parse(response.body)

    case monetization
      when 'Paid'
        app_ids = response["topCharts"][0]["adamIds"]
      when 'Free'
        app_ids = response["topCharts"][1]["adamIds"]
      when 'Grossing'
        app_ids = response["topCharts"][2]["adamIds"]
    end
  end

  # Fetches and returns the top rated apps with its meta data
  #
  # @param category_id [String] The id of the apps category
  # @param monetization [String] The monetization type of the apps to fetch 
  #         (Paid, Free, Grossing)
  # @param rank_position [Integer | nil] The rank position of the app to fetch,
  #         if a single app is requested; nil, otherwise
  # @return meta_data [Hash<String x Hash<String x String>>] The information 
  #         extracted from the Apple Lookup API
  def self.get_top_apps(category_id = "6001", 
                        monetization = "Free", 
                        rank_position = nil)
    meta_data = {}

    app_ids = fetch_top_rated_apps(category_id,  monetization)

    extract_meta_data = Proc.new do |app_info, meta_data|
      meta_data[app_info["trackId"]] = {
        app_name: app_info["trackName"],
        description: app_info["description"],
        small_icon_url: app_info["artworkUrl60"],
        publisher_name: app_info["artistName"],
        price: app_info["price"],
        version_number: app_info["version"],
        average_user_rating: app_info["averageUserRatingForCurrentVersion"]
      }
    end

    if rank_position
      fetch_meta_data_for_single_app(app_ids[rank_position - 1], 
                                      meta_data,
                                      extract_meta_data)
    else
      
      fetch_meta_data_for_multiple_apps(app_ids, 
                                        meta_data, 
                                        extract_meta_data)
    end
  end

  private

    # Fetches the meta data for multiple apps
    #
    # @param app_ids [Array[String]] An array with the apps ids
    # @param meta_data [Hash<String x Hash<String>>] The hash where the
    #         information is stored
    # @return meta_data [Hash<String x Hash<String>>] The meta_data hash
    #         updated with the apps info
    def self.fetch_meta_data_for_multiple_apps(app_ids, meta_data, proc)

      # Makes a request call to the search api for every 10 app ids
      app_ids.in_groups_of(10) do |group|
        ids = group.join(',')
        response = HTTParty.get("https://itunes.apple.com/lookup", 
                                  query: {id: ids})
        response = JSON.parse(response.body)

        # Extracts the meta data for every app
        response["results"].each do |app_info|

          proc.call(app_info, meta_data).to_json
        end
      end

      meta_data
    end

    # Fetches the meta data for a single app
    #
    # @param app_id [String] The app id
    # @param meta_data [Hash<String x Hash<String>>] The hash where the
    #         information is stored
    # @return meta_data [Hash<String x Hash<String>>] The meta_data hash
    #         updated with the app info
    def self.fetch_meta_data_for_single_app(app_id, meta_data, proc)

      response = HTTParty.get("https://itunes.apple.com/lookup", 
                              query: {id: app_id})
      response = JSON.parse(response.body)

      proc.call(response["results"].first, meta_data).to_json
    end

end