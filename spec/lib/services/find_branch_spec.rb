describe Travis::Services::FindBranch do
  let(:user)    { FactoryGirl.create(:user) }
  let(:repo)    { FactoryGirl.create(:repository, :owner_name => 'travis-ci', :name => 'travis-core') }
  let!(:build)  { FactoryGirl.create(:build, :repository => repo, :state => :finished) }
  let(:service) { described_class.new(user, params) }

  attr_reader :params

  it 'finds the last builds of the given repository and branch' do
    @params = { :repository_id => repo.id, :branch => 'master' }
    service.run.should be == build
  end

  it 'scopes to the given repository' do
    @params = { :repository_id => repo.id, :branch => 'master' }
    build = FactoryGirl.create(:build, :repository => FactoryGirl.create(:repository), :state => :finished)
    service.run.should_not be == build
  end

  it 'returns an empty build scope when the repository could not be found' do
    @params = { :repository_id => repo.id + 1, :branch => 'master' }
    service.run.should be_nil
  end

  it 'finds branches by a given id' do
    @params = { :id => build.id }
    service.run.should be == build
  end
end
