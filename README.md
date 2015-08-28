API
===========

REST API that pulls the Apple App Store top lists

Requirements
------------

* Ruby [2.2.2 or later]
* Ruby on Rails [4.2.3 or later]

Current Version
---------------

There is only one version of the API: **v1**.

Usage
-----
<!-- 
On every request add the value
**application/vnd.api.prioridata.com+json; version=X** in the header **Accept**
key, where **X** is the version number. -->

### Monetizations options
* Free
* Paid
* Grossing

### To pull the top rated apps given the category_id and the monetization

    curl 'https://dry-beach-1130.herokuapp.com/categories/:category_id/apps?monetization=:monetization'

It will return a json like the next one:

    {
      "295646461":{
        "app_name":""The Weather Channel and weather.com - local forecasts, radar maps, and storm tracking",
        "description":"Your weather. Personalized. Enjoy the best day possible with the best forecast available....",
        "small_icon_url":"http://is5.mzstatic.com/image/thumb/Purple6/v4/f4/52/f2/f452f29c-685d-c825-e8f5-ead0f64047b2/AppIcon60x60_U00402x.png/0x0ss-85.jpg",
        "publisher_name":"The Weather Channel Interactive",
        "price":0.0,
        "version_number":"6.10",
        "average_user_rating":3.5
      },
      ...
    }

### To pull a single app given the category_id, monetization and rank position

    curl 'https://dry-beach-1130.herokuapp.com/categories/:category_id/apps?monetization=:monetization&rank_position=:rank_position'

It will return a json like the next one:

    {
      "app_name":"Max Mayfield's Hurricane Tracker - WPLG Local 10",
      "description":"Max Mayfield is the former Director of the National Hurricane Center....",
      "small_icon_url":"http://is5.mzstatic.com/image/thumb/Purple5/v4/34/42/a2/3442a2e4-aeea-71c8-c76c-c9ca740afe0d/icon-iphone_U00402x.png/0x0ss-85.jpg",
      "publisher_name":"Graham Media Group, Inc",
      "price":0.0,
      "version_number":"2.7",
      "average_user_rating":3.5
    }

### To pull the top rated publishers

    curl 'https://dry-beach-1130.herokuapp.com/categories/:category_id/publishers?monetization=:monetization'

It will return a json like the next one:

    {
      ...
      449507999: {
        "publisher_name":"WBTV, LLC",
        "number_of_apps":2
        "app_names":["Carolina Hurricane Tracker","WBTV First Alert Weather"],
        "rank":17
     },
     ...
      449277037: {
        "publisher_name":"WCSC, LLC",
        "number_of_apps":1
        "app_names":["Live 5 First Alert Hurricane Tracker"],
        "rank":119
     },
     ...
    }
