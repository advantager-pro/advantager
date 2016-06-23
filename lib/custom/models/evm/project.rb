module EVM::Project
    extend ActiveSupport::Concern

    included do

      validates :evm_field, presence: true, inclusion: { in: ::Project.available_fields }
      validates :currency, presence: true, inclusion: { in: currency_ids }, if: :using_currency?
      validates :custom_unity, presence: true, if: :using_custom_unity?
      validates :evm_frequency, presence: true, numericality: { only_integer: true, greater_than: 0 }
      validate :validate_visible_fields

      available_fields.each do |field|
        define_method "evm_#{field}_based?".to_sym do
          evm_based_on?(field)
        end
      end

      safe_attributes 'evm_field', 'visible_fields', 'currency', 'evm_frequency'
    end

    def issue_evm_field
      Project.issue_field(self.evm_field)
    end

    def entry_evm_field
      Project.entry_field(self.evm_field)
    end

    def validate_visible_fields
      unless (visible_fields - (self.class.available_fields - [self.evm_field] )).empty?
        errors.add(:visible_fields, :inclusion)
      end
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

      def entry_field(field)
        "actual_#{field}".to_sym
      end

      def issue_field(field)
        "estimated_#{field}".to_sym
      end

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
