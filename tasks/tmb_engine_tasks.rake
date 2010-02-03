namespace :tmb_engine do
  desc "Syncronize extra files for TMB Engine plugin."
  task :sync do
    system "rsync -ruv --exclude '.*' vendor/plugins/tmb_engine/db/migrate db"
    system "rsync -ruv --exclude '.*' vendor/plugins/tmb_engine/public ."
  end
end