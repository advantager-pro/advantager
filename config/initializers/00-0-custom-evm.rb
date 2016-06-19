Dir["#{Rails.root}/lib/custom/models/*.rb"].each {|file| require file }
Dir["#{Rails.root}/lib/custom/models/evm/*.rb"].each {|file| require file }
puts ::EVM::Project.inspect
