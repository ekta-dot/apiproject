class Api::V1::BooksController < ApplicationController
  before_action :find_author, only: [:show, :update, :destroy]

  def index
    books = Book.all
    render json: books
  end

  def show
    render json: @book
  end

  def create
    book = Book.new(book_params)
    if book.save
      render json: author, status: :created
    else
      render json: { error: 'Unable to create author' }, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      render json: { message: 'Author successfully updated' }
    else
      render json: { error: 'Unable to update author' }, status: :unprocessable_entity
    end
  end

  def destroy
    if @book.destroy
      render json: { message: 'Author successfully deleted' }
    else
      render json: { error: 'Unable to delete author' }, status: :unprocessable_entity
    end
  end

  private

  def author_params
    params.require(:book).permit(:book_name, :author_id)
  end

  def find_author
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
  render json: {error: 'Book not found' }, status: :not_found
  end
 end
