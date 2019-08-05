require_relative '../../../app/nostra.rb'

RSpec.describe Nostra::CSVDataParser do
  # NOTE: currently using sample from actual 1Money export
  let(:subject) { Nostra::CSVDataParser.transactions('spec/fixture/1Money-sample.html') }

  it 'returns an array of hashes' do
    expect(subject).to be_a(Array)
    expect(subject.count).to eql(9)
    expect(subject.first).to be_a(Hash)
  end

  it 'has a date' do
    expect(subject[0][:date]).to eql("8/3/19")
  end
  it 'has a type' do
    expect(subject[0][:type]).to eql(:expense)
  end
  it 'has a from_account' do
    expect(subject[0][:from_account]).to eql("Chime")
  end
  # TODO: to_account can be a category, figure out how to differentiate a transfer from a category?
  it 'has a to_account' do
    expect(subject[0][:to_account]).to eql("Alcohol")
  end
  it 'has a category' do
    expect(subject[0][:category]).to eql("Alcohol")
  end
  it 'has notes' do
    expect(subject[0][:notes]).to be_nil
  end

  context 'when the transaction type is Transfer' do
    it 'has a to_account' do
      expect(subject[1][:to_account]).to eql("Debt Pool")
    end
  end
end
