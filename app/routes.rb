require_relative './nostra.rb'

post '/import/' do
  Nostra::Importer.import_csv(params[:csv_file])
  redirect '/'
end

get '/' do
  @accounts = Nostra::Account.all
  accounts_and_transactions = @accounts.collect { |account| { account: account, transactions: account.transactions } }
  json accounts_and_transactions
end

get '/accounts' do
  json @accounts = Nostra::Account.all
end

get '/accounts/:id' do
  json @account = Nostra::Account.find(params[:id])
end

get '/accounts/:id/balance' do
  @account = Nostra::Account.find(params[:id])
  json account: @account, balance: @account.balance(params[:date])
end

get '/accounts/:id/transactions' do
  @account = Nostra::Account.find(params[:id])
  json @account.transactions
end

post '/accounts' do
  @account = Nostra::Account.create(params[:account])
end

delete '/accounts/:id' do
  Nostra::Account.destroy(params[:id])
end


get '/transactions' do
  json @transactions = Nostra::Transaction.all
end

get '/transactions/:id' do
  json @transaction = Nostra::Transaction.find(params[:id])
end

post '/transactions' do
  @transaction = Nostra::Transaction.create(params[:transaction])
end

delete '/transactions/:id' do
  Nostra::Transaction.destroy(params[:id])
end
