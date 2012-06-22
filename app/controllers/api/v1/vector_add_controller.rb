class Api::V1::VectorAddController < Api::V1::BaseController
  respond_to :json
  def perform
    # get params
    result = VectorAdd.perform(params[:data][:v1], params[:data][:v2]) 
    # call vector_add
    respond_to do |wants|
      wants.json { render json: { result: result }, status: :ok }
    end
  end
end
