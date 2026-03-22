module SystemHelpers
  # Sign in via the Devise form. More reliable than Devise test helpers
  # when using a real browser driver (remote Chrome).
  def sign_in_via_form(user, password: "password123")
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    click_button "Log in"
    # Wait for Turbo to finish the redirect before returning
    expect(page).to have_text("Sign out")
  end
end

RSpec.configure do |config|
  config.include SystemHelpers, type: :system
end
