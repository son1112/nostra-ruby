require 'byebug'

require 'rom-sql'
require 'rom-repository'
require 'date'
require './nostra.rb'

config = ROM::Configuration.new(:sql, "sqlite::memory")
config.register_relation Relations::Accounts
container = ROM.container(config)

container.gateways[:default].tap do |gateway|
  migration = gateway.migration do
    change do
      create_table :accounts do
        primary_key :id
        string :name, null: false
        integer :type, null: false, default: 0
      end
    end
  end
  migration.apply gateway.connection, :up
end

repo = Repositories::Accounts.new(container)
