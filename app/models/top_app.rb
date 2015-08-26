class TopApp

  include HTTParty

  # Fetches and returns the top rated apps with its meta data
  #
  # @param category_id [String] The id of the apps category
  # @param monetization [String] The monetization type of the apps to fetch 
  #         (Paid, Free, Grossing)
  # @return [Hash<String x Hash<String>>] meta_data The information extracted
  #         from the Apple Lookup API
  def get_top_apps(category_id, monetization)
    meta_data = {}

    # Fetches the top rated apps inside the category
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

    return response.response unless response.success?

    response = JSON.parse(response.body)

    case monetization
    when 'Paid'
      app_ids = response["topCharts"][0]["adamIds"]
    when 'Free'
      app_ids = response["topCharts"][1]["adamIds"]
    when 'Grossing'
      app_ids = response["topCharts"][2]["adamIds"]
    end

    # Makes a request call to the search api for every 10 app ids
    app_ids.in_groups_of(10) do |group|
      ids = group.join(',')
      response = HTTParty.get("https://itunes.apple.com/lookup", 
                                query: {id: ids})
      response = JSON.parse(response.body)

      # Extracts the meta data for every app
      response["results"].each do |result|

        meta_data[result["trackId"]] = {
          app_name: result["trackName"],
          description: result["description"],
          small_icon_url: result["artworkUrl60"],
          publisher_name: result["artistName"],
          price: result["price"],
          version_number: result["version"],
          average_user_rating: result["averageUserRatingForCurrentVersion"]
        } 
      end


    end

    meta_data

  end

end