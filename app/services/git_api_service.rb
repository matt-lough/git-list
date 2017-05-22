require 'rest-client'
require 'httparty'

API_URL = 'https://api.github.com'

class GitApiService
  def search_repos(query='ruby', readme_filter=true)
    begin
      response = RestClient.get(API_URL+"/search/repositories?q=topic:#{query}+pushed:>2016")
      repos = JSON.parse(response)
      repos = repos['items']
      if readme_filter
        repos = filter_readme_only(repos)
      end
      repos
    rescue
      false
    end
  end

  private

  def filter_readme_only(repo_ary)
    filtered_repos = []
    repo_ary.each do |repo|
      url = find_readme_url(repo['html_url'])
      if !url.nil?
        repo['readme_url'] = url
        filtered_repos << repo
      end
    end
    filtered_repos
  end

  def git_url_to_gitraw_url(url)
    url.sub('github.com', 'raw.githubusercontent.com')
  end

  def is_404?(url)
    response = HTTParty.get(url)
    response.code == 404
  end

  # Returns first valid Readme URL or nil
  def find_readme_url(repo_url)
    html_url = git_url_to_gitraw_url(repo_url)
    file_names = ['README.md', 'README.MD', 'readme.md', 'readme.MD', 'README', 'readme']
    existing_files = file_names.select {|file| !is_404?(html_url + '/master/' + file) }
    if !existing_files.empty?
      return html_url + '/master/' + existing_files.first
    end
    nil
  end

end
