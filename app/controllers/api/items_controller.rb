class Api::ItemsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    render json: Item.all
  end

  def query
    query_response = Item.query (item_params)

    if !query_response.nil?
      if !query_response.is_a? String
        # Integer response from Item.query
        best_match = Item.find (query_response)
        best_match = best_match.category + " - " + best_match.name
        render status: 200, json: { best_match }
      else
        # String Response from Item.query
        error_msg = query_response
        render status: 422, json: { "Error" =>  error_msg }
      end
    else
      # Nil Response from Item.query
      render status: 200, json: { "Response" =>  "No Matches Found" }
    end

  end

  def create
    item = Item.new(item_params)
    if item.save
      render status: 200, json: { message: 'Success', item: item }
    else
      render status: 422, json: { message: "Item could not be created", errors: item.errors }
    end
  end

  def update
    item = Item.find (params[:id])
    if item.update (item_params)
      render status: 200, json: { message: "Item updated", item: item }
    else
      render status: 422, json: { message: "Item could not be updated", errors: item.errors }
    end
  end

  def destroy
    item = Item.find (params[:id])
    item.destroy
    render status: 200, json: { message: "Item destroyed." }
  end

  private

  def item_params
    params.require("item").permit(:name, :category, :length, :width, :height, :weight )
  end

end
