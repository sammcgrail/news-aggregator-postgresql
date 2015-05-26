require "csv"
require "pry"
require "sinatra"

articles =  CSV.read("articles.csv",headers:true)

def our_error(article, url, description)
  if article.length == 0 || url.length == 0 || description.length == 0
    true
  else false
  end
end

get "/" do
  redirect "/articles/"
end

get "/articles/" do
  erb :index, locals: { articles: articles }
end

get "/articles/new/" do
  erb :new, locals: { article: "", error_message: "" }
end

post "/articles/new/" do
  article = params["article"]
  url = params["url"]
  description = params["description"]

  if our_error(article, description, url) == false
    CSV.open("articles.csv","a") do |file|
      file << [article, url, description]
      redirect "/articles/"

  end
    redirect "/articles/new/"
   else
     erb :new, locals: {error_message: "Error", article: params["article"], url: params["url"], description: params["description"] }
  end
end
