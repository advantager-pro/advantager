module Advantager::Project
    extend ActiveSupport::Concern
    included do
      include Advantager::EVM::ProjectMethods
      include Advantager::EVM::ProjectFields      
    end

    module ClassMethods
    end
end
