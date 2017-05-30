class UserDecorator < LittleDecorator
  ##
  # default image for gravatar https://en.gravatar.com/site/implement/images#default-image
  GRAVATAR_DEFAULT = "retro"
  GRAVATAR_SIZE = "80"

  ##
  # @!group avatar

  ##
  # @param options [Hash]
  # @option options [Integer] :size eg 300
  def gravatar_url(options = {})
    size = options[:size] || GRAVATAR_SIZE
    "http://www.gravatar.com/avatar/#{email_hexdigest}?d=#{GRAVATAR_DEFAULT}&s=#{size}"
  end

  ##
  # size: 35px
  def avatar(opts = {})
    options = opts.merge(class: "avatar #{opts[:class]}")
    image_tag gravatar_url, options
  end

  ##
  # size: 150px
  def avatar_small
    image_tag gravatar_url(size: 300),
              class: "avatar avatar-big"
  end

  def avatar_with_link
    link_to avatar, record_path
  end

  # @!endgroup
  ##

  def name_with_link
    link_to name, record_path
  end

  def role_label
    content_tag :span,
                record.role,
                class: "label label-default"
  end

  private

  def email_hexdigest
    @email_hexdigest ||= Digest::MD5.hexdigest(email)
  end

  def record_path
    admin_user_path(record) if record.persisted?
  end
end
