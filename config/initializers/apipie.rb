Apipie.configure do |config|
  config.app_name                = "moi"
  config.validate                = false
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  config.markup                  = Apipie::Markup::Markdown.new
  config.app_info["1.0"]         = <<-EOS
    ## moi backend api

    resources:

    - [github repo](https://github.com/GrowMoi/moi)
    - [documentation](http://www.rubydoc.info/github/GrowMoi/moi/master)
    - [environment](https://github.com/GrowMoi/moi/wiki/environment)
  EOS

  # where is your API defined?
  config.api_controllers_matcher = File.join(
    Rails.root,
    "app",
    "controllers",
    "api",
    "**",
    "*.rb"
  )
end
