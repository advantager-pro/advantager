class BuildChartResponse

  def self.call(evm_points)
    project = evm_points.first.project

    response = {breaking_points_events:  [project.due_date.to_s] }

    return {evm_points_length: 0}.to_json if evm_points.length < 1
    
    evm_fields = %w(planned_value earned_value actual_cost)
    response[:evm_fields] = evm_fields
    response[:evm_chart_data] = data_for_morris(evm_points, fields: %w(day) + evm_fields)
    response[:evm_labels] = {}
    evm_fields.each{|f| response[:evm_labels][f] = t("evm.elements.#{f}") }

    tcpi_fields = %w(to_complete_performance_index_bac)
    response[:tcpi_fields] = tcpi_fields
    response[:tcpi_data] = data_for_morris(evm_points, fields: %w(day) + tcpi_fields)
    tcpi_fields.each{|f| response[:evm_labels][f] = t("evm.elements.#{f}") }

    performance_fields = %w(schedule_performance_index cost_performance_index performance_index to_complete_performance_index_bac)
    response[:performance_fields] = performance_fields
    response[:performance_data] = data_for_morris(evm_points, fields: %w(day) + performance_fields )
    performance_fields.each{|f| response[:evm_labels][f] = t("evm.elements.#{f}") }

    planning_fields = %w(budget_at_conclusion planned_value estimate_at_completion_calculated estimate_at_completion_cpi estimate_at_completion_cpi_and_spi  estimate_to_complete)
    response[:planning_fields] = planning_fields
    response[:planning_data] = data_for_morris(evm_points, fields: %w(day) + planning_fields)
    planning_fields.each{|f| response[:evm_labels][f] = t("evm.elements.#{f}") }

    full_fields = evm_fields + planning_fields
    response[:full_fields] = full_fields
    response[:full_data] = data_for_morris(evm_points, fields: %w(day) + full_fields)
    full_fields.each{|f| response[:evm_labels][f] = t("evm.elements.#{f}") }

    response
  end

  private

  def self.data_for_morris(evm_points, options)
    fields = options[:fields]
    project = evm_points.first.project
    n = project.evm_frequency

    pts = (n - 1).step(evm_points.size - 1, n).map do |i|
      e = evm_points[i]
      hash = {}
      fields.each do |field|
        if field == 'day'
            d = e.day
            hash[field] = "#{d.year}-#{d.month}-#{d.day}"
        else
          hash[field] = e.send(field)
        end
      end
      hash
    end
    d = project.due_date
    if d > Date.today && (fields.include?('planned_value') || fields.include?(:planned_value))
      lp = evm_points.last
      pts << { planned_value: lp.budget_at_conclusion, day: "#{d.year}-#{d.month}-#{d.day}" }
    end
    pts
  end  

  def self.t(key)
    I18n.t!(key)
  end
end