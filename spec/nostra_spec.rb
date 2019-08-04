require_relative '../app/nostra.rb'

RSpec.describe Nostra do
  context 'when importing 1money csv file' do
    # NOTE: samples based on 1Money csv export data

    # before do
    #   account.add_transactions_by_csv('spec/fixture/1Money-sample.html')
    # end

    before do
      # NOTE: this is where persistence will really come in to play
      # for now, just modeling to prove out import functions
      Nostra.import_csv('spec/fixture/1Money-sample.html')
    end

    it 'creates accounts'

    it 'has transactions' do
      # TODO: write integration tests to confirm accounts and transactions are created
      expect(1+1).to eql(2)
    end
  end
end
