class PagesController < ApplicationController
  def show
    render template: "pages/#{params[:page]}"
  end
  def show_meme
    render template: "pages/memes/#{params[:page]}", layout: false
  end
end
