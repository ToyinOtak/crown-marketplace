module FacilitiesManagement::Beta::SummaryHelper
  include FacilitiesManagement::SummaryHelper

  def calculate_uom_value(val)
    uom_value = nil
    if val[:uom_value].is_a? Numeric
      uom_value = val[:uom_value].to_f
    elsif val[:uom_value].is_a? String # rspec cases use string for the value
      uom_value = val[:uom_value].to_f
    elsif val[:uom_value][:monday][:uom].is_a? Numeric
      uom_value = 0
      Date::DAYNAMES.each { |day| uom_value += val[:uom_value][day.downcase.to_sym][:uom] }
      uom_value *= 52 # for each week in the year
      uom_value = uom_value.round(2)
    end
    uom_value
  end
end
