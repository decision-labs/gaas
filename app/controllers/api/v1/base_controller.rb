class Api::V1::BaseController < ApplicationController
  before_filter :restrict_access
  respond_to :json

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      User.where(api_key: token).exists?
    end
  end
end
