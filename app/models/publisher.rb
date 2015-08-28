class Publisher

  include HTTParty

  # Returns the top publishers rank according to amount of apps they have
  # in the top rated apps list
  #
  # @param category_id [String] The id of the apps category
  # @param monetization [String] The monetization type of the apps to fetch 
  #         (Paid, Free, Grossing)
  # @return publishers [Hash<Integer x Hash<String x String>>] The information 
  #         extracted from the Apple Lookup API
  def self.get_top_publishers(category_id, monetization)
    meta_data = {}
    publishers = {}
    i = 1

    app_ids = App.fetch_top_rated_apps(category_id, monetization)

    extract_meta_data = Proc.new do |app_info, meta_data|

      if meta_data[app_info["artistId"]]
        meta_data[app_info["artistId"]][:app_names] << app_info["trackName"]
        meta_data[app_info["artistId"]][:number_of_apps] += 1
      else
        meta_data[app_info["artistId"]] = {
          publisher_name: app_info["artistName"],
          number_of_apps: 1,
          app_names: [app_info["trackName"]]
        }
      end
    end
    
    App.fetch_meta_data_for_multiple_apps(app_ids, 
                                              meta_data, 
                                              extract_meta_data)

    publishers = meta_data.sort_by{|k,v| v[:number_of_apps]}.reverse.to_h

    publishers.each do |k, v|
      publishers[k][:rank] = i
      i += 1
    end

    publishers.to_json

  end

end