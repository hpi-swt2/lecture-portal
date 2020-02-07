require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LecturePortal
  class Application < Rails::Application
    def database_exists?
      ActiveRecord::Base.connection
    rescue ActiveRecord::NoDatabaseError
      false
    else
      true
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.active_record.default_timezone = :local
    config.active_record.time_zone_aware_attributes = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.after_initialize do
      unless defined?(Rails::Console) || Rails.env.test? || File.split($0).last == "rake" || !database_exists? then
        scheduler = Rufus::Scheduler.singleton

        # Schedule a check for aging of comprehension stamps
        scheduler.every "30s" do
          ActiveRecord::Base.connection_pool.with_connection do
            Lecture.eliminate_comprehension_stamps
          end
        end

        # Schedule a check for lecture cyclus
        scheduler.every "1m" do
          ActiveRecord::Base.connection_pool.with_connection do
            Lecture.handle_activations
          end
        end
      end
    end
  end
end
