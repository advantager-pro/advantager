class BuildChartResponse

  def self.call(evm_points, user_language)
    lang = user_language
    project = evm_points.first.project

    response = {breaking_points_events:  [project.due_date.to_s], evm_points_length: evm_points.length }

    return response if evm_points.length < 1
    
    evm_fields = %w(planned_value earned_value actual_cost budget_at_conclusion)
    response[:evm_fields] = evm_fields
    response[:evm_chart_data] = data_for_morris(evm_points, fields: evm_fields)
    response[:evm_labels] = {}
    evm_fields.each{|f| response[:evm_labels][f] = t(f, lang) }

    single_fields = ["es_schedule_performance_index", "cost_performance_index", "es_schedule_variance",
      "cost_variance", "variance_at_conclusion", "to_complete_schedule_performance_index_pd",
      "to_complete_schedule_performance_index_ieac", "to_complete_cost_performance_index_bac",
      "to_complete_cost_performance_index_cpi"]
    single_fields.each{ |field| response = add_single_field(field, evm_points, response, lang) } 

    response[:charts]  = single_fields + %w(evm)
    response
  end

  private

  def self.data_for_morris(evm_points, options)
    fields = options[:fields]
    fields += %w(day) unless options[:no_day]
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

  def self.add_single_field(field, evm_points, response, lang)
    fields = [field]
    response[:"#{field}_fields"] = fields
    response[:"#{field}_data"] = data_for_morris(evm_points, fields: fields)
    fields.each{|f| response[:evm_labels][f] = t(f, lang) }
    response
  end

  def self.t(key, lang="")
    lang = lang.empty? ? I18n.config.available_locales.first : lang
    I18n.t!("evm.elements.#{key}", locale: lang)
  end
end