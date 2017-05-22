class StaticPagesController < ApplicationController
  def home
    @repos = GitApiService.new().search_repos
  end

  def help
  end
end
