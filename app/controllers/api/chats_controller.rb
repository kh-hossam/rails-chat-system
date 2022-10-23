class Api::ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: [:show, :update, :destroy]

  def index
    @chats = @application.chats
    render json: @chats, status: :ok
  end


  def show
    render json: @chat, status: :ok
  end


  def create
    @chat = @application.chats.build
    @chat.number = get_chat_number
    if @chat.valid?
      PublisherService.publish("chats", @chat)
      render json: @chat, status: :created
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def update
    if @chat.update(params.permit())
      render json: @chat, status: :ok
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @chat.destroy
  end

  private
    def set_application
      @application = Application.find_by(token: params[:application_token])
      if @application.nil?
        render json: { message: "no application with that token" }, status: :unprocessable_entity
      end
    end

    def set_chat
      @chat = @application.chats.find_by(number: params[:number])
      if @chat.nil?
        render json: { message: "no chat with that number" }, status: :unprocessable_entity
      end
    end

    def get_chat_number
      number = $redis.get("app_#{@application.token}_chat_number")
      if !number
          $redis.set("app_#{@application.token}_chat_number", 1)
          number = 1
      end 
      $redis.incr("app_#{@application.token}_chat_number")
      number
    end

end
