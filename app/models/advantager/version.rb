module Advantager::Version
    extend ActiveSupport::Concern
    included do
      include Advantager::EVM::VersionMethods
    end

    module ClassMethods
    end
end
