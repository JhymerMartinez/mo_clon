module RequestLoginMacros
  def login_as(user)
    post_via_redirect(
      user_session_path,
      user: {
        email: user.email,
        password: user.password
      }
    )
  end
end
