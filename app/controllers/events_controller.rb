# A controller to handle incoming webhook events
class EventsController < ApplicationController
  include WebhookValidations

  before_action :verify_incoming_webhook_address!
  skip_before_action :verify_authenticity_token, :only => [:create]

  def create
    event    = request.headers["HTTP_X_GITHUB_EVENT"]
    delivery = request.headers["HTTP_X_GITHUB_DELIVERY"]

    if valid_events.include?(event)
      Rails.logger.debug("create_event=#{event} valid=true delivery=#{delivery} event_params=#{event_params}")
      request.body.rewind

      Resque.enqueue(Receiver, event, delivery, event_params)

      render :json => {}, :status => :created
    else
      Rails.logger.debug("create_event=#{event} valid=false delivery=#{delivery} event_params=#{event_params}")
      render :json => {}, :status => :unprocessable_entity
    end
  end

  def valid_events
    %w{deployment deployment_status status ping}
  end

  private

  def event_params
    params.permit!
  end
end
