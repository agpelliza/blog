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
Dir["./filters/**/*.rb"].each { |rb| require rb }

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

  def posts
    posts = []
    last_post = nil
    Dir[File.join(File.expand_path(File.dirname(__FILE__)), "posts", "*.md")].sort.reverse.each do |file| 
      post = Post[file]
      post.previous = last_post

      last_post.next = post unless last_post.nil?
      last_post = post
      posts << post
    end
    return posts
  end

  def find_post(post_id)
    posts.select {|post| post.id == post_id}.first
  end

  on root do
    render("home", title: "Blog", posts: posts)
  end

  on "posts/:id" do |id|
    post = find_post(id)

    render("post", title: post.title, post: post)
  end
end
