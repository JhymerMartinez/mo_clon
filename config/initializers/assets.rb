# Be sure to restart your server when you modify this file.

# Enable serving of images, stylesheets, and JavaScripts from an asset server.
Rails.application.config.action_controller.asset_host = Rails.application.secrets.url

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  *.woff
  admin.js
  admin.css
  tutor.js
  tutor.css
)
