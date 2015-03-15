class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :approve, :destroy]

  respond_to :html

  def index
    @requests = current_user.incoming_requests.order("created_at asc").page(params[:page])
    respond_with(@requests)
  end

  def show
    respond_with(@request)
  end

  def new
    @request = Request.new
    respond_with(@request)
  end

  def create
    @request = Request.new(request_params)
    if @request.save
      notification = Notification.new(user_id: @request.owner_id, read: false, reason: "request_document", from_user_id: @request.requester_id, document_id: @request.document_id)
      notification.save!
      # UserMailer.request_notification(@request).deliver
      flash[:success] = I18n.t("requests.created_msg")
      redirect_to @request.document
    end
  end

  def approve
    approval = Approval.new(category_id: @request.document.category_id, user_id: @request.requester_id)
    if approval.save
      @request.destroy
    end
    redirect_to requests_path
  end

  def destroy
    @request.destroy
    respond_with(@request)
  end

  private
    def set_request
      @request = Request.find(params[:id])
    end

    def request_params
      params[:request]
      params.require(:request).permit(:owner_id, :requester_id,
                                       :document_id, :description)
    end
end
