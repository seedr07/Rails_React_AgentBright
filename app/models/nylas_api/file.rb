class NylasApi::File
  attr_reader :id, :account

  def initialize(token:, id:)
    @account = NylasApi::Account.new(token).retrieve
    @id = id
  end

  def fetch
    @account.files.find(id)
  end
end
