require 'httparty'
require 'json'

# Google trends really does not want to scrape their data. For some reason this code cannot create a valid token
# I am only able to with the browser
class TrendsScraper
  def scrape
    keyword = 'amazon'
    explore_token_url = <<~EXPLORE
      https://trends.google.com/trends/api/explore?hl=en-US&tz=420&req=
      {
        "comparisonItem":[{"keyword":"#{keyword}","geo":"","time":"today+12-m"}],
        "category":0,
        "property":""
      }
      &tz=420
    EXPLORE

    headers = {
      'authority': 'trends.google.com',
      'sec-ch-ua': '" Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"',
      'accept': 'application/json, text/plain, */*',
      'sec-ch-ua-mobile': '?0',
      'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
      'sec-ch-ua-platform': '"Windows"',
      'x-client-data': 'CJG2yQEIpbbJAQjEtskBCKmdygEI/uXKAQjq8ssBCJD0ywEInvnLAQjX/MsBCOeEzAEIy4nMAQisjswBCNKPzAEIvZDMAQjZkMwBCJqRzAEIn5PMARiMnssB',
      'sec-fetch-site': 'same-origin',
      'sec-fetch-mode': 'cors',
      'sec-fetch-dest': 'empty',
      'referer': 'https://trends.google.com/trends/explore?q=amazon&geo=US',
      'accept-language': 'en-US,en;q=0.9',
      'cookie': 'CONSENT=YES+US.en+201910; HSID=AVZ4J0qfmugAsMVbe; SSID=A_VkrtxqL9JFqiRGQ; APISID=5u34jScT20j7_Nyg/AvRCYw7ktV8K6K9Hh; SAPISID=_R_asbYY5AD_Maxy/A0LDchX5iFV6xFi-7; __Secure-3PAPISID=_R_asbYY5AD_Maxy/A0LDchX5iFV6xFi-7; __Secure-1PAPISID=_R_asbYY5AD_Maxy/A0LDchX5iFV6xFi-7; OGPC=19025836-2:; SID=FQhui-OCUoYtnW8loLC4EA7DfgF8cIBAXnMRig27O_nyorZjPJWqLE6sU3aTkHAvQMiF0A.; __Secure-1PSID=FQhui-OCUoYtnW8loLC4EA7DfgF8cIBAXnMRig27O_nyorZjy8sLBkbUB2qxotXuqIh5Hg.; __Secure-3PSID=FQhui-OCUoYtnW8loLC4EA7DfgF8cIBAXnMRig27O_nyorZj4y3k2M1vouplHBEZi2N0Vw.; S=billing-ui-v3=eDsvjnkOEq753Rewo5hjQU5umLouew7Z:billing-ui-v3-efe=eDsvjnkOEq753Rewo5hjQU5umLouew7Z:grandcentral=tUoDBdrdgE48hccT4w81t9M8UjuePwQ3; SEARCH_SAMESITE=CgQIu5QB; NID=511=Xn_8PQn_64b5_62GoRfkStjRlzUaZ55ug-l0wvEgABQ1LQ2yYmoTspIh8Gw-eyfTPaz_acJCMrcWzeGL09RklCp7ucDDgG_lcdPdGYIFeY0EddDFWEokqoLZ0HnzKDdmhFhALkcMs_NKqwS56sGtt4j3UMKhQl53z3N5jDvkAVEdG6ViU3p0uWBrtFh5nLKh-SEuQcc7yTF2fJ_uQqn-inCTjtZhUDYRAiExbt_I8VeV9UvOmPafSjkFRB_N7e2_lHQtd9ngG2M4Vd6xZQHJsm9hUI1SLJYl3uJwwPopAUv8mjn3MQ7lNgZxnIuqi3zCtgKouUk_e-RK0X0K94tXKM4kOQNp7iAuwzECNutkiqkh2SazZtI9t1utotePRQ3qt-rnI1EmftjuGhEILHW8VK9uQQ1i_cf59O8lSSK0JuLfg--ldZ0n6PqfN3xsyeWDD9dX; 1P_JAR=2022-01-11-17; SIDCC=AJi4QfEer9oPoKuBXoaAm53ZBEODhKj88YyiLZ19PZTWW_Uj_qWndvhWW7D3vr0nsnwqZSCCHuk; __Secure-3PSIDCC=AJi4QfEyLreeO5mmDnLzenN9KTd7XxS2MGoj-Dee_lrLzjL7gTpruy3URYrGxHsADVgI9hqDv4Q',
    }
    token_data = HTTParty.get(smash(explore_token_url), headers: headers).body
    token = token_data.split('"token":"').last.split('"').first
    
    #token = "APP6_UEAAAAAYd8IKl2ych-HukRk9Xz-Bz1MKUFOdDcE"

    puts token

    date_today = Date.today
    date_last_year = date_today - 1.year

    data_url = <<~DATA
      https://trends.google.com/trends/api/widgetdata/multiline?hl=en-US&tz=420&req=
      {
        "time":"#{date_last_year}+#{date_today}",
        "resolution":"WEEK",
        "locale":"en-US",
        "comparisonItem":
          [
            {
              "geo":{"country":"US"},
              "complexKeywordsRestriction":{"keyword":[{"type":"BROAD","value":"#{keyword}"}]}
            }
          ],
        "requestOptions":{"property":"","backend":"IZG","category":0}
      }
      &token=#{token}
      &tz=420
    DATA

    # data_headers = {
    #   'authority': 'trends.google.com',
    #   'sec-ch-ua': '" Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"',
    #   'accept': 'application/json, text/plain, */*',
    #   'sec-ch-ua-mobile': '?0',
    #   'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
    #   'sec-ch-ua-platform': '"Windows"',
    #   'x-client-data': 'CJG2yQEIpbbJAQjEtskBCKmdygEI/uXKAQjq8ssBCJD0ywEInvnLAQjX/MsBCOeEzAEIy4nMAQisjswBCNKPzAEIvZDMAQjZkMwBCJqRzAEIn5PMARiMnssB',
    #   'sec-fetch-site': 'same-origin',
    #   'sec-fetch-mode': 'cors',
    #   'sec-fetch-dest': 'empty',
    #   'referer': 'https://trends.google.com/trends/explore?q=amazon&geo=US',
    #   'accept-language': 'en-US,en;q=0.9',
    #   'cookie': 'CONSENT=YES+US.en+201910; HSID=AVZ4J0qfmugAsMVbe; SSID=A_VkrtxqL9JFqiRGQ; APISID=5u34jScT20j7_Nyg/AvRCYw7ktV8K6K9Hh; SAPISID=_R_asbYY5AD_Maxy/A0LDchX5iFV6xFi-7; __Secure-3PAPISID=_R_asbYY5AD_Maxy/A0LDchX5iFV6xFi-7; __Secure-1PAPISID=_R_asbYY5AD_Maxy/A0LDchX5iFV6xFi-7; OGPC=19025836-2:; SID=FQhui-OCUoYtnW8loLC4EA7DfgF8cIBAXnMRig27O_nyorZjPJWqLE6sU3aTkHAvQMiF0A.; __Secure-1PSID=FQhui-OCUoYtnW8loLC4EA7DfgF8cIBAXnMRig27O_nyorZjy8sLBkbUB2qxotXuqIh5Hg.; __Secure-3PSID=FQhui-OCUoYtnW8loLC4EA7DfgF8cIBAXnMRig27O_nyorZj4y3k2M1vouplHBEZi2N0Vw.; S=billing-ui-v3=eDsvjnkOEq753Rewo5hjQU5umLouew7Z:billing-ui-v3-efe=eDsvjnkOEq753Rewo5hjQU5umLouew7Z:grandcentral=tUoDBdrdgE48hccT4w81t9M8UjuePwQ3; SEARCH_SAMESITE=CgQIu5QB; NID=511=Xn_8PQn_64b5_62GoRfkStjRlzUaZ55ug-l0wvEgABQ1LQ2yYmoTspIh8Gw-eyfTPaz_acJCMrcWzeGL09RklCp7ucDDgG_lcdPdGYIFeY0EddDFWEokqoLZ0HnzKDdmhFhALkcMs_NKqwS56sGtt4j3UMKhQl53z3N5jDvkAVEdG6ViU3p0uWBrtFh5nLKh-SEuQcc7yTF2fJ_uQqn-inCTjtZhUDYRAiExbt_I8VeV9UvOmPafSjkFRB_N7e2_lHQtd9ngG2M4Vd6xZQHJsm9hUI1SLJYl3uJwwPopAUv8mjn3MQ7lNgZxnIuqi3zCtgKouUk_e-RK0X0K94tXKM4kOQNp7iAuwzECNutkiqkh2SazZtI9t1utotePRQ3qt-rnI1EmftjuGhEILHW8VK9uQQ1i_cf59O8lSSK0JuLfg--ldZ0n6PqfN3xsyeWDD9dX; 1P_JAR=2022-01-11-16; SIDCC=AJi4QfGpbvu-yGP751dd3-eFbPtKe3xhHfIsQOLGZyfaSGpIK7HLtLH1naz1pxNMmg5m1pSg2KM; __Secure-3PSIDCC=AJi4QfEKGbdqj1uaf9Be65rXHM7uj_7U5venk9cLgfesryZKJERVeSEjAv-c8GIGXX9qYzGYsJw',
    # }

    puts smash(data_url)

    trend_data = HTTParty.get(smash(data_url))
    trend_data = trend_data.to_s.split(")]}',\n").last
    foo = JSON.parse(trend_data)
    pp foo

  end

  def smash(url)
    url.squish.gsub(' ', '')
  end
end