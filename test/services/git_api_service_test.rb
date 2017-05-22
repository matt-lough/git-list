require "test_helper"

class GitApiServiceTest < ActiveSupport::TestCase
  test 'it searches repos' do
    assert !GitApiService.new().search_repos.empty?
  end
end
