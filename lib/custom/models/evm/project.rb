module EVM::Project
    extend ActiveSupport::Concern

    included do

      validates :evm_field, presence: true, inclusion: { in: self.available_fields }
      validates :visible_fields, inclusion: { in: proc { |record| self.available_fields - [record.evm_field] } }, allow_blank: true
      validates :currency, presence: true, inclusion: { in: currency_ids }, if: :using_currency?
      validates :custom_unity, presence: true, if: :using_custom_unity?
      validates :evm_frequency, presence: true, numericality: { only_integer: true, greater_than: 0 }

      available_fields.each do |field|
        define_method "evm_#{field}_based?".to_sym do
          evm_based_on?(field)
        end
      end

      safe_attributes 'evm_field', 'visible_fields', 'currency', 'evm_frequency'
    end

    def evm_frequency
      read_attribute(:evm_frequency) || self.class.default_evm_frequency
    end

    def using_currency?
      using_field?('cost')
    end

    def using_custom_unity?
      using_field?('custom')
    end

    def evm_based_on?(field)
      evm_field == field.to_s
    end

    def using_field?(field)
      evm_based_on?(field) || visible_fields.include?(field)
    end

    module ClassMethods

      def default_evm_frequency
        6
      end

      def available_fields
        @@available_fields ||= %w(time point cost custom)
      end

      def currency_ids
        @@currency_ids ||= Money::Currency.table.keys.map(&:to_s)
      end
    end
end
