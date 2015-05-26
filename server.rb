require "csv"
require "pry"
require "sinatra"
require "pg"

def db_connection
  begin
    connection = PG.connect(dbname: "articles")
    yield(connection)
  ensure
    connection.close
  end
end

get "/articles" do
  articles = db_connection { |conn| conn.exec("SELECT name FROM articles") }
  erb :index, locals: { articles: articles }
end

get "/articles/:article" do
  erb :show, locals: { article: params[:article] }
end

post "/articles" do
  # Read the input from the form the user filled out
  title = params["article"]
  url = params["url"]
  description = params["description"]


  # Insert new article into the database
  db_connection do |conn|
    conn.exec_params("INSERT INTO articles (name) VALUES ($1, $2, $3)", [title, url, desription])
  end

  # Send the user back to the home page which shows
  # the list of articles
  redirect "/articles"
end




# articles =  CSV.read("articles.csv",headers:true)
#
# def our_error(article, url, description)
#   if article.length == 0 || url.length == 0 || description.length == 0
#     true
#   else false
#   end
# end
#
# get "/" do
#   redirect "/articles/"
# end
#
# get "/articles/" do
#   erb :index, locals: { articles: articles }
# end
#
# get "/articles/new/" do
#   erb :new, locals: { article: "", error_message: "" }
# end
#
# post "/articles/new/" do
#   article = params["article"]
#   url = params["url"]
#   description = params["description"]
#
#   if our_error(article, description, url) == false
#     CSV.open("articles.csv","a") do |file|
#       file << [article, url, description]
#       redirect "/articles/"
#
#   end
#     redirect "/articles/new/"
#    else
#      erb :new, locals: {error_message: "Error", article: params["article"], url: params["url"], description: params["description"] }
#   end
# end
