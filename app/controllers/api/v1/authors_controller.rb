class Api::V1::AuthorsController < ApplicationController

before_action :find_author, only: [:show, :update, :destroy]

  def index
    authors = Author.all
    render json: authors
  end

  def show
    render json: @author  
  end

  
 def create
    author = Author.new(author_params)
    if author.save
      render json: author, status: :created
    else
      render json: { error: 'Unable to create author' }, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      render json: { message: 'Author successfully updated' }
    else
      byebug
      render json: { error: 'Unable to update author' }, status: :unprocessable_entity
    end
  end

  def destroy
    if @author.destroy
      render json: { message: 'Author successfully deleted' }
    else
      render json: { error: 'Unable to delete author' }, status: :unprocessable_entity
    end
  end

  private
  def author_params
    params.require(:author).permit(:author_name, :author_surname)
  end

  def find_author 
    @author = Author.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    render json: { error: 'Author not found' }, status: :not_found
  end
 
 end