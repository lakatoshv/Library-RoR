json.extract! book, :id, :title, :auth, :zhanr, :pages_qty, :description, :image_url, :created_at, :updated_at
json.url book_url(book, format: :json)
