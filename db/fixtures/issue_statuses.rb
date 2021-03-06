# #Default Issue status
default_issue_status = IssueStatus.seed(:id, {id: 1, name: I18n.t!("default_issue_status_new"), is_closed: false, position: 1, default_done_ratio: nil}).first

pro =IssueStatus.seed(:id,{id: 2, name: I18n.t!("default_issue_status_in_progress"), is_closed: false, position: 2, default_done_ratio: nil}).first

clo = IssueStatus.seed(:id, {id: 3, name: I18n.t!("default_issue_status_closed"), is_closed: true, position: 3, default_done_ratio: 100}).first

rej = IssueStatus.seed(:id, {id: 4, name: I18n.t!("default_issue_status_rejected"), is_closed: false, position: 4, default_done_ratio: nil}).first

statuses = {default_issue_status_new: default_issue_status, default_issue_status_in_progress: pro, default_issue_status_closed: clo, default_issue_status_rejected: rej}
statuses.each do |translation, model|
  I18n.available_locales.each  do |loc|
    model.update_attributes(name: I18n.t!(translation, locale: loc), locale: loc)
  end
end
