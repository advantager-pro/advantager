def override_default(name, value)
  return unless ActiveRecord::Base.connection.table_exists? Setting.table_name
  Setting.send("#{name}=", value) if Setting.where(name: name).first.nil?
end

override_default('login_required', "1")
override_default('ui_theme', "PurpleMine2")