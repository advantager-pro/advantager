class BuildChartResponse

  def self.call(project, user_language)
    lang = user_language
    evm_points = project.evm_points
    response = {breaking_points_events:  [project.due_date.to_s], evm_points_length: evm_points.length }
 
    return response if evm_points.length < 1
   
    evm_fields = %w(planned_value earned_value actual_cost budget_at_conclusion)
    response[:evm_fields] = evm_fields
    response[:evm_chart_data] = data_for_morris(project, fields: evm_fields)
    response[:evm_labels] = {}
    evm_fields.each{|f| response[:evm_labels][f] = t(f, lang) }

    single_fields = ["es_schedule_performance_index", "cost_performance_index", "es_schedule_variance",
      "cost_variance", "variance_at_conclusion", "to_complete_schedule_performance_index_pd",
      "to_complete_schedule_performance_index_ieac", "to_complete_cost_performance_index_bac",
      "to_complete_cost_performance_index_cpi"]
    single_fields.each{ |field| response = add_single_field(field, project, response, lang) } 

    # Add AC field to bac based TCPI 
    response[:to_complete_cost_performance_index_bac_fields] << 'actual_cost'

    response[:charts]  = single_fields + %w(evm)
    response
  end

  private

  def self.data_for_morris(project, options)
    fields = options[:fields]
    fields += %w(day) unless options[:no_day]
    # We need to use ordered data to build the chart
    evm_points = project.evm_points.order("day ASC")

    max_index = evm_points.length - 1
    indexes = (0..max_index).step(project.evm_frequency).to_a
    indexes << max_index unless indexes.last == max_index
    response_points = indexes.map do |index|
      e = evm_points[index]
      hash = {}
      fields.each do |field|
        if field == 'day'
            d = e.day
            hash[field] = "#{d.year}-#{d.month}-#{d.day}"
        elsif field == 'to_complete_cost_performance_index_bac'
          hash.merge!(tcpi_bac_fix!(point: e, lang: options[:lang]))
        else
          hash[field] = e.send(field)
        end
      end
      hash
    end

    due_date = project.due_date > Date.today ? project.due_date : Date.today
    if due_date > Date.today && (fields.include?('planned_value') || fields.include?(:planned_value))
      most_recent_point = project.most_recent_point
      response_points << { planned_value: most_recent_point.budget_at_conclusion, day: "#{due_date.year}-#{due_date.month}-#{due_date.day}" }
    end
    response_points
  end  

  def self.add_single_field(field, project, response, lang)
    fields = [field]
    response[:"#{field}_fields"] = fields
    response[:"#{field}_data"] = data_for_morris(project, { fields: fields, lang: lang })
    fields.each{|f| response[:evm_labels][f] = t(f, lang) }
    response
  end

  def self.t(key, lang="")
    lang = lang.empty? ? I18n.config.available_locales.first : lang
    I18n.t!("evm.elements.#{key}", locale: lang)
  end

  def self.tcpi_bac_fix!(point:, lang: )
    bac = point.budget_at_conclusion(point.day).round(2)
    ac = point.actual_cost.round(2)
    if ac >= bac
      { 
        to_complete_cost_performance_index_bac: nil,
        actual_cost: ac,
        tcpi_explanation: I18n.t!('evm.tcpi_bac_overflow', actual_cost: ac, bac: bac, locale: lang) }
    else
      { 
        to_complete_cost_performance_index_bac: point.to_complete_cost_performance_index_bac,
        actual_cost: nil
      }
    end
  end
end