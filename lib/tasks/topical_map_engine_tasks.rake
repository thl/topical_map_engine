namespace :topical_map do
  desc "Syncronize extra files for Topical Map Engine plugin."
  task :sync do
    system "rsync -ruv --exclude '.*' vendor/plugins/topical_map_engine/db/migrate db"
    system "rsync -ruvK --exclude '.*' vendor/plugins/topical_map_engine/public ."
  end
  
  desc "Installs dependent plugins for topical map engine."
  task :install_dependencies do
    git_installers = { 'active_resource_extensions' => 'git://github.com/thl/active_resource_extensions.git', 'acts_as_tree' => 'git://github.com/rails/acts_as_tree.git', 'mms_integration' => 'git://github.com/thl/mms_integration.git', 'places_integration' => 'git://github.com/thl/places_integration.git', 'tiny_mce' => 'git://github.com/kete/tiny_mce.git' }
    
    if Rails.root.join('.git').exist?
      git_installers.each do |plugin, url| 
        path = "vendor/plugins/#{plugin}"
        system "git submodule add #{url} #{path}" if !Rails.root.join(path).exist?
      end
    else
      git_installers.each { |plugin, url| system "script/plugin install #{url}" if !Rails.root.join('vendor', 'plugins', plugin).exist? }
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