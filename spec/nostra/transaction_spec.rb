require_relative '../../app/nostra.rb'

RSpec.describe Nostra::Transaction do
  let(:date) { [2019, 03, 24] }
  let(:transaction_data) do
    {
      amount: 100,
      date: date,
    }
  end
  let(:subject) { described_class.new(transaction_data) }

  it 'can be initialized' do
    expect(subject).to be_a(described_class)
  end

  it 'has an amount' do
    expect(subject.amount).to eql(100)
  end

  it 'has a date' do
    expect(subject.date).to eql(Date.parse('2019-03-24'))
  end

  context 'when date not provided' do
    let(:date) { nil }

    it 'defaults to today' do
      expect(subject.date).to eql(Date.today)
    end
  end

  context 'when recurring' do
    before do
      transaction_data[:recurring] = recurring_type
    end

    let(:recurring_type) { nil }

    context 'daily' do
      let(:recurring_type) { Nostra::RecurringType::DAILY }

      it 'sets next_transaction_date' do
        expect(subject.next_transaction_date).to eql(subject.date + 1)
      end

      it 'can get a collection of recurring transactions' do
        expect(subject.get_recurring(Date.new(2019, 7, 23))).to be_a(Array)
      end
    end
    context 'weekly' do
      let(:recurring_type) { Nostra::RecurringType::WEEKLY }

      it 'sets next_transaction_date' do
        expect(subject.next_transaction_date).to eql(subject.date + 7)
      end
    end
    context 'bi_weekly' do
      let(:recurring_type) { Nostra::RecurringType::BI_WEEKLY }

      it 'sets next_transaction_date' do
        expect(subject.next_transaction_date).to eql(subject.date + 14)
      end
    end
    context 'monthly' do
      let(:recurring_type) { Nostra::RecurringType::MONTHLY }

      it 'sets next_transaction_date' do
        expect(subject.next_transaction_date).to eql(subject.date >> 1)
      end
    end
    context 'bi_monthly' do
      let(:recurring_type) { Nostra::RecurringType::BI_MONTHLY }

      it 'sets next_transaction_date' do
        expect(subject.next_transaction_date).to eql(subject.date >> 2)
      end
    end
    context 'tri_monthly' do
      let(:recurring_type) { Nostra::RecurringType::TRI_MONTHLY }

      it 'sets next_transaction_date' do
        expect(subject.next_transaction_date).to eql(subject.date >> 3)
      end
    end
    context 'yearly' do
      let(:recurring_type) { Nostra::RecurringType::YEARLY }

      it 'sets next_transaction_date' do
        expect(subject.next_transaction_date).to eql(subject.date >> 12)
      end
    end
    context 'unsupported type' do
      let(:recurring_type) { :quarterly }

      it 'sets next_transaction_date' do
        expect { subject.next_transaction_date }.to raise_error('recurring type not supported!')
      end
    end
  end
end
