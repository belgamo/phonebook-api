require 'rails_helper'

def check_attributes(parsed_contact, target_contact)
  expect(parsed_contact[:name]).to eq(target_contact[:name])
  expect(parsed_contact[:email]).to eq(target_contact[:email])
  expect(parsed_contact[:city]).to eq(target_contact[:city])
  expect(parsed_contact[:birthday]).to eq(target_contact[:birthday])
end

RSpec.describe :Contact, type: :request do
  describe 'GET /index' do
    let!(:contacts_list) { create_list(:contact, 2) }
    before { get contacts_path, headers: headers }
    
    it 'returns 200 as http response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct body' do
      parsed_contacts = parse_json

      expect(parsed_contacts.size).to eq(2)

      parsed_contacts.each do |contact|
        check_attributes(contact, contacts_list.find {|c| c.id === contact[:id]} )
      end
    end
  end

  describe 'GET /show' do
    before { get contact_path(target_contact) }

    context 'when the contact exists' do
      let(:target_contact) { create(:contact) }

      it 'returns 200 as http response' do        
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct body' do        
        contact = parse_json

        check_attributes(contact, target_contact)
        expect(contact[:phone_numbers]).to eq([])
      end
    end

    context 'when the contact is not found' do
      let(:target_contact) { 'inexistent' }

      it 'returns 404 as http response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message in the body' do
        expect(parse_json[:message]).to eq("Couldn't find Contact with 'id'=inexistent")
      end
    end
  end

  describe 'POST /create' do
    subject(:create_contact) do
      post contacts_path, params: { contact: contact_params }
    end

    context 'with valid data' do
      let(:contact_params) do
        attributes_for(:contact)
      end

      it 'returns 200 as http response' do
        create_contact

        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct body' do 
        create_contact

        contact = parse_json

        check_attributes(contact, contact_params)
        expect(contact[:phone_numbers]).to eq([])
      end

      it 'persists register in the database' do
        expect { create_contact }.to change { Contact.count }.from(0).to(1)
      end
    end

    context 'with valid phone_numbers' do
      let!(:phone_number_params) do
        { phone_numbers_attributes: [attributes_for(:phone_number), attributes_for(:phone_number)] }
      end
      
      let(:contact_params) do
        attributes_for(:contact).merge(phone_number_params)
      end

      it 'returns 200 as http response' do
        create_contact

        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct body' do 
        create_contact

        contact = parse_json

        base_array = phone_number_params[:phone_numbers_attributes]
        target_array = contact[:phone_numbers]

        phone_number_params[:phone_numbers_attributes].each do | item |
          expect(contact[:phone_numbers]).to include(a_hash_including(item))
        end
      end

      it 'persists register in the database' do
        expect { create_contact }.to change { PhoneNumber.count }.from(0).to(2)
      end
    end

    context 'with invalid data' do
      let(:contact_params) do
        attributes_for(:contact, name: "")
      end

      it 'returns 400 as http response' do
        create_contact
        
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error message in the body' do
        create_contact
        
        expect(parse_json[:message]).to eq("Validation failed: Name can't be blank")
      end

      it 'does not persist in the database' do        
        expect { create_contact }.to_not change { Contact.count }
      end
    end
  end

  describe 'UPDATE /patch' do
    subject(:update_contact) do
      patch contact_path(contact_params), params: { contact: contact_params }
    end

    let!(:contacts_list) { create_list(:contact, 2) }
    
    context 'with valid data' do
      let(:contact_params) do
        target_contact = contacts_list.second
        attributes_for(:contact, id: target_contact.id, name: "Gabriel")
      end

      it 'returns 200 as http response' do
        update_contact

        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct body' do 
        update_contact

        contact = parse_json
        check_attributes(contact, contact_params)
      end

      it 'updates register in the database' do
        target_contact = Contact.second
        expect { update_contact }.to change { Contact.second.name }.from(target_contact.name).to("Gabriel")
      end
    end
  end
end
