module FavoritesHelper
  def fave_or_unfave_button(movie, favorite)
    if favorite
      button_to "❤️", movie_favorite_path(movie, favorite), method: :delete
    else
      button_to "🤍", movie_favorites_path(movie)
    end
  end
end
