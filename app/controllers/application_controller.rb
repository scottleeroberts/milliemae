class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout :for_devise

  def for_devise
    'author'
  end
end

