module Api
  module Gstar
    class ShopsController < ApplicationController      
      skip_before_action :verify_authenticity_token

      def ndList
      	nds = Retailer.all.pluck(:nd).uniq.compact
      	render :json => {result: true,object: nds}
      end

      def rdList
      	nd = params[:nd]
      	if nd != nil
      		rds = Retailer.where(nd: params[:nd]).pluck(:sales_channel).uniq.compact
      		render :json => {result: true,object: rds}
      	else
      		render :json => {result: false,errors: {messages: ['Please add nd name!']}}
      	end
      	
      end

      def shopList
      	shopList = Retailer.where(sales_channel: params[:rd]).select(:retailer_code,:retailer_name)
       	render :json => {result: true,object: shopList}
      end

    end
  end
end  