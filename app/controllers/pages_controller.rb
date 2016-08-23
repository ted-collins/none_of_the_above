class PagesController < ApplicationController

  before_filter :sanitize_params

  def show
    render template: "pages/#{params[:page]}"
  end

  def show_meme
	params.require(:page)
	case params[:page].to_i
	when 0
		@meme_url = 'clinton_trump_meme_00.jpg'
	when 1
		@meme_url = 'clinton_trump_meme_01.jpg'
	else
		@meme_url = 'clinton_trump_meme_00.jpg'
	end
    render template: "pages/memes/meme", layout: false
  end

protected
  def sanitize_params
	params.permit(:page)
  end
end
