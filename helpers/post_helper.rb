module PostHelper
  def posts
    posts = []
    last_post = nil
    Dir["./posts/*.{md,html}"].sort.reverse.each do |file| 
      post = Post[file]
      post.next = last_post

      last_post.previous = post unless last_post.nil?
      last_post = post
      posts << post
    end
    return posts
  end

  def find_post(post_id)
    posts.select {|post| post.id == post_id}.first
  end
end