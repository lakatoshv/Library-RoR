class BooksController < ApplicationController
 before_action :set_book, only: [:show, :edit, :update, :destroy]
 helper_method :sort_column, :sort_direction
  # GET /books
  # GET /books.json
  def index
    if params[:direction]
      session[:sort_by] = params[:direction]
    else
      session[:sort_by] = "title"
    end
    if params[:type_sort]
      session[:type_sort] = params[:type_sort]
    else
      session[:type_sort] = "asc"
    end
    if params[:search]
      books = Book.search(params[:search])
      books = books.order(sort_column + " " + sort_direction)
      @books = books.paginate(page: params[:page], per_page: 5)
    else
      books = Book.order(sort_column + " " + sort_direction)
      @books = books.paginate(page: params[:page], per_page: 5)
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @kritics = Kritic.search(@book.title)
    @vidguks = Vidguk.search(@book.title)
    @kritic = Kritic.new
    @vidguk = Vidguk.new
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Книга успішно додана' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Книга успішно змінена' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Книга успішно видалена' }
      format.json { head :no_content }
    end
  end

  private
    def sort_column
      #params[:sort]|| "title"
      params[:sort]||session[:sort_by]
    end

    def sort_direction
      #params[:direction]||"asc"
      params[:direction]||session[:type_sort]
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :auth, :zhanr, :pages_qty, :description, :image_url, :mini_description)
    end
end