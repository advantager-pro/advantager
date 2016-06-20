module EVM::Project
    extend ActiveSupport::Concern

    included do
      validates :evm_field, presence: true, inclusion: { in: self.available_fields }
      validates :visible_fields, inclusion: { in: proc { |record| self.available_fields - [record.evm_field] } }, allow_blank: true
      validates :currency, presence: true, inclusion: { in: currency_ids }, if: :using_currency?
      validates :custom_unity, presence: true, if: :using_custom_unity?

      safe_attributes 'evm_field', 'visible_fields', 'currency'
    end


    def using_currency?
      using_field_for_evm?('cost')
    end

    def using_custom_unity?
      using_field_for_evm?('custom_unity')
    end

    def using_field_for_evm?(field)
      evm_field == field || visible_fields.include?(field)
    end
    
    module ClassMethods
      def available_fields
        @@available_fields ||= %w(time point cost custom)
      end

      def currency_ids
        @currency_ids ||= Money::Currency.table.keys.map(&:to_s)
      end
    end
end
