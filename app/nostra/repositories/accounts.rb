module Repositories
  class Accounts < ROM::Repository[:accounts]
    commands :create

    def [](id)
      accounts.by_id(id).one!
    end

    def [](name)
      accounts.by_name(name).one!
    end

    def [](type)
      accounts.by_type(type).one!
    end
  end
end
