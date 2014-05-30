module Service
  class MagicStrings
    include Combi::Service

    def actions
      [:magic_strings]
    end

    def uuid(message)
      SecureRandom.uuid
    end

  end
end
