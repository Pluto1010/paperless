require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'atom'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Paperless
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.active_job.queue_adapter = :delayed_job  # Or :resque or :sidekiq
    config.tag_colors = {
      crimson: 'Crimson',
      red: 'Red',
      darkred: 'DarkRed',
      hotpink: 'HotPink',
      deeppink: 'DeepPink',
      mediumvioletred: 'MediumVioletRed',
      lightsalmon: 'LightSalmon',
      coral: 'Coral',
      orangered: 'OrangeRed',
      orange: 'Orange',
      gold: 'Gold',
      darkkhaki: 'DarkKhaki',
      lavender: 'Lavender',
      plum: 'Plum',
      violet: 'Violet',
      magenta: 'Magenta',
      blueviolet: 'BlueViolet',
      purple: 'Purple',
      indigo: 'Indigo',
      slateblue: 'SlateBlue',
      darkslateblue: 'DarkSlateBlue',
      lime: 'Lime',
      limegreen: 'LimeGreen',
      palegreen: 'PaleGreen',
      mediumseagreen: 'MediumSeaGreen',
      green: 'Green',
      paleturquoise: 'PaleTurquoise',
      darkturquoise: 'DarkTurquoise',
      cadetblue: 'CadetBlue',
      steelblue: 'SteelBlue',
      lightsteelblue: 'LightSteelBlue',
      skyblue: 'SkyBlue',
      deepskyblue: 'DeepSkyBlue',
      dodgerblue: 'DodgerBlue',
      mediumblue: 'MediumBlue',
      navy: 'Navy',
      silver: 'Silver',
      gray: 'Gray',
      black: 'Black'
    }

    config.middleware.delete Rack::Lock
    config.middleware.use FayeRails::Middleware, mount: '/faye', :timeout => 25 do
      map '/document-status' => RealtimeDocumentStatusController
      map default: :block
    end
  end
end
