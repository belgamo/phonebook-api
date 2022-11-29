class ContactsController < ApplicationController 
  before_action :contact, only: [:show, :update, :destroy]

  def index
    render json: Contact.all
  end

  def create
    contact = Contact.create!(contact_params)

    render json: contact
  end

  def show
    render json: @contact
  end

  def update
    @contact.update!(contact_params)
    
    render json: @contact
  end

  def destroy
    @contact.destroy!

    render json: @contact
  end

  private

  def contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :city, :email, :birthday)
  end
end