require "csv"
require "pry"
require "sinatra"
require "pg"

#method to open a conn to psql db

def db_connection
  begin
    connection = PG.connect(dbname: "news_aggregator")
    yield(connection)
  ensure
    connection.close
  end
end

get "/" do
  redirect "/articles"
end
get "/articles/" do
  redirect "/articles"
end

get "/articles" do
  articles = db_connection { |conn| conn.exec("SELECT * FROM articles") }
  erb :index, locals: { articles: articles }
  db_connection do |connection|
    connection.exec("SELECT * FROM articles;")
  end
  erb :index, locals: { article: params[:article] }
end

get "/articles/new" do
  erb :new
end

post "/articles/new" do
  # Read the input from the form the user filled out
  title = params[:title]
  url = params[:url]
  description = params[:description]

  # Insert new article into the database   - safe mode
  sql2 = "INSERT INTO articles(title, url, description)
    VALUES ($1, $2, $3);"
  db_connection do |connection|
    connection.exec_params(sql2, [title, url, description])
  end


  # Send the user back to the home page which shows
  # the list of articles
  redirect "/articles"
end





# old code
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
