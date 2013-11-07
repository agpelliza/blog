require "cuba"
require "mote"
require "cuba/contrib"
require "rack/protection"
require "shield"
require "maruku"

Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::TextHelpers
Cuba.plugin Shield::Helpers

Dir["./models/**/*.rb"].each  { |rb| require rb }
Dir["./routes/**/*.rb"].each  { |rb| require rb }

Dir["./helpers/**/*.rb"].each { |rb| require rb }
Dir["./lib/**/*.rb"].each { |rb| require rb }

Cuba.plugin PostHelper

Cuba.use Rack::MethodOverride
Cuba.use Rack::Session::Cookie,
  key: "blog",
  secret: "d1e5d77ee7feb98f1a312f9e32e054cc2ed0c72b"

Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer

Cuba.use Rack::Static,
  urls: %w[/js /css /img],
  root: "./public"

Cuba.define do
  persist_session!

  on root do
      render("home", title: "Blog", posts: posts)
    end

    on "post/:id" do |id|
      post = find_post(id)

      render("post", title: post.title, post: post)
    end

    on default do
      res.redirect "/"
    end
end
