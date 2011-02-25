namespace :kmaps do
  desc "Syncronize extra files for KMaps Engine plugin."
  task :sync do
    system "rsync -ruv --exclude '.*' vendor/plugins/kmaps_engine/db/migrate db"
    system "rsync -ruvK --exclude '.*' vendor/plugins/kmaps_engine/public ."
  end
  
  desc "Installs dependent plugins for kmaps engine."
  task :install_dependencies do
    git_installers = { 'active_resource_extensions' => 'git://github.com/thl/active_resource_extensions.git', 'acts_as_tree' => 'git://github.com/rails/acts_as_tree.git', 'mms_integration' => 'git://github.com/thl/mms_integration.git', 'places_integration' => 'git://github.com/thl/places_integration.git', 'tiny_mce' => 'git://github.com/kete/tiny_mce.git' }
    if File.exists?(File.join(RAILS_ROOT, '.git'))
      git_installers.each do |plugin, url| 
        path = "vendor/plugins/#{plugin}"
        system "git submodule add #{url} #{path}" if !File.exists?(File.join(RAILS_ROOT, path))
      end
    else
      git_installers.each { |plugin, url| system "script/plugin install #{url}" if !File.exists?(File.join(RAILS_ROOT, "vendor/plugins/#{plugin}")) }
    end
  end
  
  namespace :cache do
    desc "Deletes view cache"
    task :view_cleanup do |t|
      Dir.chdir('public') do
        ['categories', 'documents', 'media_objects', 'places'].each{ |folder| `rm -rf #{folder}` }
        ['json', 'xml'].each{ |ext| `rm categories.#{ext}` }
      end
    end
  end
end