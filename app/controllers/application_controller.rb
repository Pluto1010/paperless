class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #before_action :provide_wallpaper

  helper_method :right_menu_toggle_icon

  def right_menu_toggle_icon
    icon = "tags"
    if @right_menu_mode == :search
      icon = "search"
    end
    icon
  end

  def provide_wallpaper
    if session[:wallpaper] and DateTime.parse(session[:wallpaper_expiretime]) > DateTime.now
      puts "Wallpaper: #{session[:wallpaper]}"
      @wallpaper = session[:wallpaper]
      return
    end

    old_wallpaper = session[:wallpaper]

    loop do
      @wallpaper = session[:wallpaper] = get_wallpapers.sample
      break if @wallpaper != old_wallpaper
    end

    session[:wallpaper_expiretime] = DateTime.now + 5.minutes
  end

  private
  attr_accessor :right_menu_mode

  def get_wallpapers
    feed_url = 'https://api.flickr.com/services/feeds/groups_pool.gne?id=42097308@N00'
    feed = Atom::Feed.load_feed(URI.parse(feed_url))
    images = []

    feed.each_entry do |entry|
      image_links = entry.links.keep_if { |link| link.type == 'image/jpeg' }
      images += image_links.collect { |link| link = link.href }
    end
    images
  end
end
