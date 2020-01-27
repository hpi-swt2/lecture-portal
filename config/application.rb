require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LecturePortal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.active_record.default_timezone = :local
    config.active_record.time_zone_aware_attributes = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Schedule a check for aging of comprehension stamps
    config.after_initialize do
      ActiveRecord::Base.connection_pool.with_connection do
        Lecture.eliminate_comprehension_stamps
        Lecture.handle_activations
      end

      Rufus::Scheduler.singleton.every '30s' do
        ActiveRecord::Base.connection_pool.with_connection do
          Lecture.eliminate_comprehension_stamps
        end
      end

      Rufus::Scheduler.singleton.every '1m' do
        ActiveRecord::Base.connection_pool.with_connection do
          Lecture.handle_activations
        end
      end
    end
  end
end
