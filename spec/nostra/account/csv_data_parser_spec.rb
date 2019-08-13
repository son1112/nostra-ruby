require_relative '../../../app/nostra.rb'

RSpec.describe Nostra::CSVDataParser do
  # NOTE: currently using sample from actual 1Money export
  let(:subject) { Nostra::CSVDataParser.transactions('spec/fixture/1Money-sample.html') }
  let(:transaction_sample) { subject[0] }
  let(:transfer_transaction_sample) { subject[1] }

  # TODO: considerations for type testings
  # Grant: ...expectations on the class type might not be the best thing... what if you
  # want to define a special collection/enumerable type for Transactions? it might
  # inherit from array, but i don't know if it would pass this test. Same for the
  # Hash, if you replace it with some kind of struct.
  # That being said, the Dry/Rom way seems to be adding more type concepts to ruby,
  # and it might be worth finding the resilient ways of testing these sorts of "type checks"

  it 'returns an array' do
    expect(subject).to be_a(Array)
  end
  it 'returns an array containing hashes' do
    expect(subject.first).to be_a(Hash)
  end
  it 'has the correct number of transactions' do
    expect(subject.count).to eql(9)
  end

  # TODO: break out a row parser and test there
  it 'has a date' do
    expect(transaction_sample[:date]).to eql("8/3/19")
  end
  it 'has a type' do
    expect(transaction_sample[:type]).to eql(:expense)
  end
  it 'has a from_account' do
    expect(transaction_sample[:from_account]).to eql("Chime")
  end
  # TODO: to_account can be a category, figure out how to differentiate a transfer from a category?
  it 'has a to_account' do
    expect(transaction_sample[:to_account]).to eql("Alcohol")
  end
  it 'has a category' do
    expect(transaction_sample[:category]).to eql("Alcohol")
  end
  it 'has notes' do
    expect(transaction_sample[:notes]).to be_nil
  end

  context 'when the transaction type is Transfer' do
    it 'has a to_account' do
      expect(transfer_transaction_sample[:to_account]).to eql("Debt Pool")
    end
  end
end
