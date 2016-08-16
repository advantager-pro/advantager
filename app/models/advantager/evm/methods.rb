module Advantager::EVM::Methods
    extend ActiveSupport::Concern

    included do

      def budget_at_conclusion(date=nil)
        return _budget_at_conclusion if self.is_a?(::Project)
        project._budget_at_conclusion
      end

      def schedule_variance(date=nil)
        earned_value(date) - planned_value(date)
      end

      def cost_variance(date=nil)
        earned_value(date) - actual_cost(date)
      end

      def variance_at_conclusion(eac, date=nil)
        budget_at_conclusion(date) - eac
      end

      def schedule_performance_index(date=nil)
        earned_value(date) / planned_value(date)
      end

      def cost_performance_index(date=nil)
        earned_value(date) / actual_cost(date)
      end

      def estimate_at_completion_asc(etc_asc, date=nil)
      # EAC = AC + ETC ascendente # EAC ascendente
        actual_cost(date) + etc_asc
      end

      def estimate_at_completion_calculated(date=nil)
      # EAC = AC + (BAC - EV) # EAC calculada en términos del presupuesto aprobado
        actual_cost(date) + (budget_at_conclusion(date) - earned_value(date))
      end

      def performance_index(date=nil)
        schedule_performance_index(date) * cost_performance_index(date)
      end

      def estimate_at_completion_cpi(date=nil)
        # EAC = BAC / CPI # EAC considerando el CPI
        budget_at_conclusion(date) / cost_performance_index(date)
      end

      def estimate_at_completion_cpi_and_spi(date=nil)
      # EAC = AC + [(BAC -  EV) / (CPI × SPI)] # EAC considerando el CPI y SPI
        actual_cost(date) + ( (budget_at_conclusion(date) - earned_value(date)) / ( cost_performance_index(date) * schedule_performance_index(date) ) )
      end

      # Estimate To Complete
      def estimate_to_complete(date=nil)
        # ETC =  (BAC  - EV) / CPI # ETC calculada
        (budget_at_conclusion(date) - earned_value(date)) / cost_performance_index(date)
      end

      def to_complete_performance_index_bac(date=nil)
        # TCPI = ( BAC - EV ) / ( BAC - AC ) # Teniendo en cuenta el presupuesto inicial
        ( budget_at_conclusion(date) - earned_value(date) ) / ( budget_at_conclusion(date) - actual_cost(date) )
      end

      def to_complete_performance_index(eac, date=nil)
        # TCPI = ( BAC - EV ) / ( EAC- AC )  # Teniendo en cuenta la estimación a la conclusión
        ( budget_at_conclusion(date) - earned_value(date) ) / ( eac - actual_cost(date) )
      end
  end
end
