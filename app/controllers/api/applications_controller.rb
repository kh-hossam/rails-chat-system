class Api::ApplicationsController < ApplicationController
    before_action :set_application, only: [:show, :update, :destroy]
  
    def index
      render json: Application.all
    end
  
  
    def show
      render json: @application 
    end
  
  
    def create
      @token = Digest::SHA1.hexdigest([Time.now, rand].join)

      @application = Application.create({
          name: params[:name],
          token: @token
      })

      if @application.save
        render json: @application, status: :created
      else
        render json: { message: "Validation failed", errors: @application.errors }, status: :unprocessable_entity
      end
    end
  
  
    def update
      if @application.update(params.permit(:name))
        render json: @application, status: :ok
      else
        render json: { message: "Validation failed", errors: @application.errors }, status: :unprocessable_entity
      end
    end
  
  
    def destroy
      @application.destroy
    end
  
    private
      def set_application
        @application = Application.find_by(token: params[:token])
        if @application.nil?
          render json: { message: "no application with that token" }, status: :unprocessable_entity
        end
      end

  end