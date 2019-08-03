require_relative '../../app/nostra.rb'

RSpec.describe Nostra::Account do
  let(:account) { Nostra::Account.new }

  it 'can be initialized' do
    expect(account).to be_a(Nostra::Account)
  end

  context 'when adding transactions' do
    let(:expense_data) do
      [{ type: :expense, amount: 200 }]
    end

    let(:income_data) do
      [{ type: :income, amount: 1000 }]
    end

    before(:each) { account.reset }

    context 'when adding transactions' do
      context 'without providing transaction type' do
        transaction_data = [{ amount: 150 }]

        it 'raises an error' do
          expect{account.add_transactions(transaction_data)}.to raise_error('unsupported transaction type!')
        end
      end
      context 'without specifying an amount'
      context 'adding a single expense' do
        before(:each) do
          account.reset
          account.add_transactions(expense_data)
        end

        let(:expenses) { account.expenses }
        let(:expense) { expenses.first }

        it 'has a single expense' do
          expect(expenses.count).to eql(1)
          expect(expense).to be_a(Nostra::Expense)
          expect(expense).to be_a(Nostra::Transaction)
          expect(expense.amount).to eql(200)
        end

        it 'has a balance' do
          expect(account.transactions.count).to eql(1)
          expect(account.balance).to eql(-200)
        end
      end
      context 'adding a single income' do
        before do
          account.add_transactions(income_data)
        end

        let(:incomes) { account.incomes }
        let(:income) { incomes.first }

        it 'has a single income' do
          expect(account.incomes.count).to eql(1)
          expect(income).to be_a(Nostra::Income)
          expect(income).to be_a(Nostra::Transaction)
          expect(income.amount).to eql(1000)
        end

        it 'has a balance' do
          expect(account.balance).to eql(1000)
        end
      end
      context 'adding multiple transactions' do
        before do
          account.add_transactions(transaction_data)
        end

        let(:transaction_data) do
          expense_data + expense_data + income_data + income_data
        end

        it 'has incomes' do
          expect(account.incomes.count).to eql(2)
        end
        it 'has expenses' do
          expect(account.expenses.count).to eql(2)
        end
        it 'has a balance' do
          expect(account.balance).to eql(1600)
        end
      end
      context 'adding additional transactions' do
        before do
          account.add_transactions(expense_data + income_data)
          account.add_transactions(income_data + income_data)
        end

        it 'adds additional transactions' do
          expect(account.transactions.count).to eql(4)
        end

        it 'maintains correct balance' do
          expect(account.balance).to eql(2800)
        end
      end
    end
  end

  context 'when retrieving balance' do
    let(:expense_data) do
      [{ type: :expense, amount: 200 }]
    end

    let(:income_data) do
      [{ type: :income, amount: 1000 }]
    end

    let(:transaction_data) do
      expense_data + income_data
    end

    before(:each) do
      account.reset
      account.add_transactions(transaction_data)

      puts account.transactions.count
    end

    it 'defaults to current date balance' do
      expect(account.balance).to eql(800)
    end

    context 'with future date' do
      let(:expense_data_1) do
        [{ type: :expense, amount: 100, date: [2019, 7, 17] }]
      end
      let(:expense_data_2) do
        [{ type: :expense, amount: 100, date: [2019, 8, 17] }]
      end
      let(:expense_data_3) do
        [{ type: :expense, amount: 100, date: [2019, 9, 17] }]
      end
      let(:income_data_1) do
        [{ type: :income, amount: 100, date: [2019, 3, 17] }]
      end
      let(:income_data_2) do
        [{ type: :income, amount: 100, date: [2020, 3, 17] }]
      end

      let(:transaction_data) do
        expense_data_1 + expense_data_2 + expense_data_3 + income_data_1 + income_data_2
      end

      before(:each) do
        account.reset
        account.add_transactions(transaction_data)
      end

      it 'has the correct number of transactions' do
        expect(account.transactions.count).to eql(5)
      end

      it 'returns the correct balance up to and including the given date' do
        expect(account.balance([2019, 9, 18])).to eql(-200)
        expect(account.balance([2020, 4, 19])).to eql(-100)
      end

      # TODO: mock and control Date.today
      context 'with recurring transactions' do
        let(:income_data) do
          [{ type: :income, amount: 100, recurring: :monthly }]
        end

        let(:transaction_data) { income_data }

        before(:each) do
          account.reset
          account.add_transactions(transaction_data)
        end

        it 'calculates correct balance' do
          expect(account.balance([2019, 10, 31])).to eql(400)
        end
      end
    end
    context 'with past date'
  end
end
