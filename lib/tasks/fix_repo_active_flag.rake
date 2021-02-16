namespace :repo_active_flag do
  task :fix => [:environment] do
    puts "fixing repository stuff"
    Repository.where("active = 't'").update_all(active: 1)
    Repository.where("active = 'f'").update_all(active: 0)
  end
end
