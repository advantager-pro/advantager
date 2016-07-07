Dir["#{Rails.root}/lib/custom/models/*.rb"].each {|file| require file }
Dir["#{Rails.root}/lib/custom/models/evm/*.rb"].each {|file| require file }
# 
# Date.class_eval do
#   def self.today
#     Time.now.to_date - 1.days
#   end
# end
