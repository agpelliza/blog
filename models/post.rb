class Post
  attr_reader :id
  attr_reader :title
  attr_reader :body

  attr_accessor :next
  attr_accessor :previous

  def initialize(id, title, body)
    @id = id
    @title = title
    @body = body
  end

  def self.[](file)
    new(id(file), title(file), body(file))
  end

  protected

  def self.id(file)
    File.basename(file, File.extname(file))
  end
  
  def self.title(file)
    markdown(file).match(/>(.*?)<\/h1>/).captures.first
  end

  def self.body(file)
    markdown(file)
  end

  def self.markdown(file)
    Maruku.new(read(file)).to_html
  end

  def self.read(file)
    File.read(file, encoding: "utf-8")
  end
end