namespace :kmaps do
  desc "Syncronize extra files for KMaps Engine plugin."
  task :sync do
    system "rsync -ruv --exclude '.*' vendor/plugins/kmaps_engine/db/migrate db"
    system "rsync -ruvK --exclude '.*' vendor/plugins/kmaps_engine/public ."
  end
end