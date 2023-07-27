#
# This liquid tag constructs a link element with a high resolution preview image 
# which is meant to be replaced by an embedding iframe on click.
#
# Usage:
#    {% video url [image] [alt] %}

require 'json'
require 'erb'

class Video < Liquid::Tag
  YouTube = /youtu(?:\.be\/|be\.com\/watch\?v=)([^\&\?\/]+)/
  Vimeo = /vimeo\.com\/([^\/]+)/
  WithImage = /^(.+)\s+(.+)\s*$/m
  WithImageAndAlt = /^(.+)\s+(.+)\s+(.+)\s*$/m
  WithImageAndAltAndRatio = /^(.+)\s+(.+)\s+(.+)\s+(.+)\s*$/m

  def initialize(tagName, markup, parse_context)
    super

    if markup =~ WithImageAndAltAndRatio
      @url = Liquid::Variable.new(Regexp.last_match(1), parse_context)
      @image = Liquid::Variable.new(Regexp.last_match(2), parse_context)
      @alt = Liquid::Variable.new(Regexp.last_match(3), parse_context)
      @ratio = Liquid::Variable.new(Regexp.last_match(4), parse_context)
    elsif markup =~ WithImageAndAlt
      @url = Liquid::Variable.new(Regexp.last_match(1), parse_context)
      @image = Liquid::Variable.new(Regexp.last_match(2), parse_context)
      @alt = Liquid::Variable.new(Regexp.last_match(3), parse_context)
    elsif markup =~ WithImage
      @url = Liquid::Variable.new(Regexp.last_match(1), parse_context)
      @image = Liquid::Variable.new(Regexp.last_match(2), parse_context)
    else
      @url = Liquid::Variable.new(markup, parse_context)
    end

    @defaultImage = Liquid::Variable.new("site.data.style.default-video-thumbnail", parse_context)
    @defaultAlt = Liquid::Variable.new("site.data.style.default-video-alternative", parse_context)

    @@cache = Jekyll::Cache.new('Videos')
  end

  def render(context)
    url = @url.render(context)

    if @image
      image = @image.render(context)
    end

    if @alt
      alt = @alt.render(context)
    end

    ratio = if @ratio
      @ratio.render(context)
    else
      "16/9"
    end

    id, image, alt = @@cache.getset("#{url}#{image}#{alt}") do
      if url =~ YouTube
        getYouTubeImage(Regexp.last_match(1), image, alt)
      elsif url =~ Vimeo
        getVimeoImage(Regexp.last_match(1), image, alt)
      end
    end

    image ||= @defaultImage.render(context)
    alt ||= @defaultAlt.render(context)

    # blank lines at start and end are because of Markdown
    <<-EOF

    <a class="video-embed" href="#{url}" rel="noopener" target="_blank" data-id="#{id}" data-ratio="#{ratio}">
      <img src="#{image}" alt="#{alt}" />
    </a>

    EOF
  end

  def getVimeoImage(id, image, alt)
    if not image
      uri = URI('https://vimeo.com/api/oembed.json')
      uri.query = URI.encode_www_form({:width => 1920, :height => 1080, :url => "https://vimeo.com/#{id}"})
      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)
        image = data["thumbnail_url"]

        if not alt
          alt = "Play video '#{data["title"]}'"
        end
      else
        print "Vimeo API: #{id} could not be loaded\n"
      end
    end

    return id, image, alt
  end

  def getYouTubeImage(id, image, alt)
    if not image
      response = Net::HTTP.get_response("img.youtube.com", "/vi/#{id}/maxresdefault.jpg")

      if response.is_a?(Net::HTTPSuccess)
        image = "https://img.youtube.com/vi/#{id}/maxresdefault.jpg"
      else
        image = "https://img.youtube.com/vi/#{id}/mqdefault.jpg"
      end
    end

    return id, image, alt
  end

  Liquid::Template.register_tag "video", self
end
