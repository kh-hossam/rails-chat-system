class Api::MessagesController < ApplicationController
    before_action :set_application
    before_action :set_chat
    before_action :set_message, only: [:show, :update , :destroy]


    def index
        @messages = @chat.messages
        render json: @messages
    end


    def create
        @message = @chat.messages.build(message_params)
        @message.number = get_message_number
        if @message.valid?
            PublisherService.publish("messages", @message)
            render json: @message, status: :created
        else
            render json: @message.errors , status: :unprocessable_entity
        end
    end

    def search 
        @messages= Message.elastic_search(params['query'], @chat).records
        render json: @messages 
    end
    
    def show
        render json: @message
    end

    def update
        if @message.update(message_params)
            render json: @message, status: :ok
        else
            render json: @message.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @message.destroy
    end


    private
    def set_application
        @application = Application.find_by(token: params[:application_token])
        if @application.nil?
            render json: { message: "no application with that token" }, status: :unprocessable_entity
        end
    end

    def set_chat
        @chat = @application.chats.find_by(number: params[:chat_number])
        if @chat.nil?
            render json: { message: "no chat with that number" }, status: :unprocessable_entity
        end
    end

    def set_message
        @message = @chat.messages.find_by(number: params[:number])
        if @message.nil?
            render json: { message: "no message with that number" }, status: :unprocessable_entity
        end
    end

    def message_params
        params.permit(:body)
    end 

    def get_message_number
        number = $redis.get("app_#{@application.token}_chat_#{@chat.number}_message_number")
        if !number
            $redis.set("app_#{@application.token}_chat_#{@chat.number}_message_number", 1)
            number = 1
        end 
        $redis.incr("app_#{@application.token}_chat_#{@chat.number}_message_number")
        number
    end
end
