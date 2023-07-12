require 'rails_helper'

RSpec.describe Api::V1::AuthorsController, type: :controller do
  
  describe "GET #index" do
    it "returns a JSON response with all authors" do
      author1 = FactoryBot.create(:author)
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([author1.as_json])
    end
  end

  describe "GET #show" do
    context "when the author exists" do
      it "returns a JSON response with the author" do
        author = FactoryBot.create(:author)

        get :show, params: { id: author.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(author.as_json)
      end
    end

    context "when the author does not exist" do
      it "returns a JSON response with an error message" do
        get :show, params: { id: 123 }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ "error" => "Author not found" })
      end
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new author and returns a JSON response with the created author" do
        author_params = { author: { author_name: "John", author_surname: "Doe" } }
        post :create, params: author_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include("author_name" => "John", "author_surname" => "Doe")
      end
    end

    context "with invalid parameters" do
      it "returns a JSON response with an error message" do
        author_params = { author: { author_name: nil, author_surname: nil } }
        post :create, params: author_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ "error" => "Unable to create author" })
      end
    end
  end

  describe "PATCH #update" do
    context "when the author exists" do
      context "with valid parameters" do
        it "updates the author and returns a JSON response with a success message" do
          author = FactoryBot.create(:author)
          new_author_params = { author: { author_name: "Jane" } }
          patch :update, params: { id: author.id, author: new_author_params }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq({ "message" => "Author successfully updated" })
          expect(author.reload.author_name).to eq("Jane")
        end
      end

      context "with invalid parameters" do
        it "returns a JSON response with an error message" do
          author = FactoryBot.create(:author)
          invalid_author_params = { author: { author_surname: nil } }
          patch :update, params: { id: author.id, author: {author_name: nil} }
          expect(response).to have_http_status(422)
          expect(JSON.parse(response.body)).to eq({ "error" => "Unable to update author" })
          expect(author.reload.author_name).not_to be_nil
        end
      end
    end

    context "when the author does not exist" do
      it "returns a JSON response with an error message" do
        patch :update, params: { id: 123 , author: { author_name: "Jane" } }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ "error" => "Author not found" })
      end
    end
  end

  describe "DELETE #destroy" do
  context "when the author exists" do
    it "destroys the author and returns a JSON response with a success message" do
      author = FactoryBot.create(:author)
      delete :destroy, params: { id: author.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ "message" => "Author successfully deleted" })
      expect { Author.find(author.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "when the author does not exist" do
    it "returns a JSON response with an error message" do
      delete :destroy, params: { id: 123 }
      expect(response).to have_http_status(:not_found)
      
      expect(JSON.parse(response.body)).to eq({ "error" => "Author not found" })
    end
  end
end

end 