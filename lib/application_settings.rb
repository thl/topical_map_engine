module ApplicationSettings
  def self.application_root_id
    settings = Rails.cache.fetch('application_settings/application_root', :expires_in => 1.day) do
      str = self.settings['application_root']
      str.blank? ? nil : str.to_i
    end
  end

  def self.resource_link_target
    settings = Rails.cache.fetch('application_settings/resource_link_target', :expires_in => 1.day) do
      str = self.settings['resource_link_target']
      str = nil if str.blank?
      str
    end
  end
  
  private
  
  def self.settings
    settings = Rails.cache.fetch('application_settings/hash', :expires_in => 1.day) do
      settings_file = Rails.root.join('config', 'settings.yml')
      settings_file.exist? ? YAML.load_file(settings_file) : {}
    end
  end
end