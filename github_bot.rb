require 'open-uri'
require 'rubygems'
require 'hpricot'
module Github
  module Bot
    USER_AGENT = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_5; en-us) AppleWebKit/525.26.2 (KHTML, like Gecko) Version/3.2 Safari/525.26.12'
    GITHUB_URI = 'http://github.com/'
    
    def self.info_on(username)
      user_uri = GITHUB_URI+username+'/'
      repos = []

      page = Hpricot(open(user_uri, 'User-Agent' => USER_AGENT))
      (page/".projects").each do |project|
        tmp = (project/".project/.title")
        (tmp/"a").each do |link|
          repos.push({ :name =>link.inner_html })
          repo_uri = user_uri + link.inner_html + '/commits/master'
          
          commit_page = Hpricot(open(repo_uri,'User-Agent' => USER_AGENT))
          date = ((commit_page/"#commit/.separator").first/("h2")).inner_html.split('-')
          repos.last[:date] = Date.new(date[0].to_i,date[1].to_i,date[2].to_i) #Year day month transformed into year moth day
          
          branches = ((commit_page/"#repo_sub_menu/.site"))
          tag_found = false
          
          repos.last[:tag] = tag_found
        end
      end
      repos
    end
  end
end

