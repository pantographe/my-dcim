# frozen_string_literal: true

class ExternalAppRequestsController < ApplicationController
  include ActionController::Live

  before_action :set_external_app_request

  def show
    respond_to do |format|
      format.json do
        render json: { status: @external_app_request.status,
                       progress: @external_app_request.progress }
      end
      format.event_stream do
        sse_response do |sse|
          loop do
            sse.write({ status: @external_app_request.status,
                        progress: @external_app_request.progress })

            break if @external_app_request.finished?

            @external_app_request.reload
            sleep 1
          end
        end
      end
    end
  end

  def destroy
    @external_app_request.destroy

    redirect_to external_app_records_path
  end

  private

  def set_external_app_request
    authorize! @external_app_request = ExternalAppRequest.find(params[:id])
  end

  def sse_response(**)
    response.headers["Content-Type"] = Mime[:event_stream]

    sse = SSE.new(response.stream, **)

    yield(sse)
  ensure
    sse.close
  end
end
