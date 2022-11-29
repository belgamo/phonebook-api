class ContactsController < ApplicationController 
  before_action :contact, only: [:show, :update, :destroy]

  def index
    render json: Contact.all
  end

  def create
    contact = Contact.create!(contact_params)

    render json: contact, include: [:phone_numbers]
  end

  def show
    render json: @contact, include: [:phone_numbers]
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
    params.require(:contact).permit(:name, :city, :email, :birthday, phone_numbers_attributes: [:number, :number_type])
  end
end