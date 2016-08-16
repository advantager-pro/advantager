module Advantager::EVM::VersionMethods
    extend ActiveSupport::Concern

    included do

      ::Project.available_fields.each do |field|

        define_method "estimated_#{field}".to_sym do
          issue_field =  ::Project.issue_field(field)
          unless self.instance_variable_defined?("@#{issue_field}")
            self.instance_variable_set("@#{issue_field}", fixed_issues.sum(issue_field).to_f)
          end
          self.instance_variable_get("@#{issue_field}")
        end

        define_method "spent_#{field}".to_sym do
          entry_field = ::Project.entry_field(field)
          unless self.instance_variable_defined?("@#{entry_field}")
            self.instance_variable_set("@#{entry_field}",
              ::TimeEntry.joins(:issue).where("#{::Issue.table_name}.fixed_version_id = ?", id).sum(entry_field).to_f)
          end
          self.instance_variable_get("@#{entry_field}")
        end

        define_method "actual_#{field}".to_sym do
          self.send("spent_#{field}")
        end
      end

    end


    module ClassMethods
    end
end
