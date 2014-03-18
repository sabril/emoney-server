namespace :server do
  desc 'update server key'
  task :update_key => :environment do 
    puts "Begin"
    s = ServerSetting.first
    unless s
      s = ServerSetting.create(key: SecureRandom.hex(32))
    else
      s.update_key
    end 
    puts "Key: #{s.key}"
    puts "Done."
  end
end