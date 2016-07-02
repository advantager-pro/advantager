module EVM::ProjectMethods
    extend ActiveSupport::Concern

    included do

      # validates :evm_field, presence: true, inclusion: { in: ::Project.available_fields }

    end

    # def intance_method_x
    # end

    module ClassMethods

    end
end
