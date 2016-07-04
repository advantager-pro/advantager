module EVM::ProjectMethods
    extend ActiveSupport::Concern

    included do
      def budget_at_conclusion
        Rails.cache.fetch("#{cache_key}/budget_at_conclusion", expires_in: 5.minutes) do
          sum = 0
          issues.each{ |e| sum += e.planned_value }
          sum
        end
      end

      def planned_value
        Rails.cache.fetch("#{cache_key}/planned_value", expires_in: 15.minutes) do
          ::Evm::Point.grouped_by_day(self).last.planned_value
        end
      end

      def actual_cost
        Rails.cache.fetch("#{cache_key}/actual_cost", expires_in: 15.minutes) do
          ::Evm::Point.grouped_by_day(self).last.actual_cost
        end
      end

      def earned_value
        Rails.cache.fetch("#{cache_key}/earned_value", expires_in: 15.minutes) do
          ::Evm::Point.grouped_by_day(self).last.earned_value
        end
      end

      def schedule_variance
        earned_value - planned_value
      end

      def cost_variance
        earned_value - actual_cost
      end

      def variance_at_conclusion(eac)
        budget_at_conclusion - eac
      end

      def schedule_performance_index
        earned_value / planned_value
      end

      def cost_performance_index
        earned_value / actual_cost
      end

      def estimate_at_completion_asc(etc_asc)
      # EAC = AC + ETC ascendente # EAC ascendente
        actual_cost + etc_asc
      end

      def estimate_at_completion_calculated
      # EAC = AC + (BAC - EV) # EAC calculada en términos del presupuesto aprobado
        actual_cost + (budget_at_conclusion - earned_value)
      end

      def estimate_at_completion_cpi
        # EAC = BAC / CPI # EAC considerando el CPI
        budget_at_conclusion / cost_performance_index
      end

      def estimate_at_completion_cpi_and_spi
      # EAC = AC + [(BAC -  EV) / (CPI × SPI)] # EAC considerando el CPI y SPI
        actual_cost + ( (budget_at_conclusion - earned_value) / ( cost_performance_index * schedule_performance_index ) )
      end

      # Estimate To Complete
      def estimate_to_complete
        # ETC =  (BAC  - EV) / CPI # ETC calculada
        (budget_at_conclusion - earned_value) / cost_performance_index
      end

      def to_complete_performance_index_bac
        # TCPI = ( BAC - EV ) / ( BAC - AC ) # Teniendo en cuenta el presupuesto inicial
        ( budget_at_conclusion - earned_value ) / ( budget_at_conclusion - actual_cost )
      end

      def to_complete_performance_index(eac)
        # TCPI = ( BAC - EV ) / ( EAC- AC )  # Teniendo en cuenta la estimación a la conclusión
        ( budget_at_conclusion - earned_value ) / ( eac - actual_cost )
      end

      # validates :evm_field, presence: true, inclusion: { in: ::Project.available_fields }
      after_create do
        Evm::BreakPoint.create_minimum(self, self.created_at)
      end

      after_update do
        if evm_frequency.has_changed?
          today = Date.today
          break_points.destroy_all
          Evm::BreakPoint.generate_until(self, today)
          Evm::BreakPoint.create_minimum(self, today)
        end
      end
    end

    module ClassMethods
    end
end
