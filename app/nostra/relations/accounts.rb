module Relations
  class Accounts < ROM::Relation[:sql]
    schema(:accounts) do
      attribute :id, Types::Serial
      attribute :name, Types::String
      attribute :type, Types::Integer
    end

    def by_id(id)
      where(id: id)
    end

    def by_name(name)
      where(name: name)
    end

    def by_type(type)
      where(type: type)
    end
  end
end
