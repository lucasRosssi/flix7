class MoviesController < ApplicationController
  add_flash_types(:danger)

  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    @movies = Movie.released
  end

  def show
    @movie = Movie.find(params[:id])
    @fans = @movie.fans
    @critics = @movie.critics
    @genres = @movie.genres.order(:name)

    if current_user
      @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end  
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
  
    if @movie.update(movie_params)
      redirect_to @movie, notice: "Movie successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @movie = Movie.new
    @selected_genre = Genre.find(params[:selected_genre])

    if @selected_genre
      @movie.genre_ids = [@selected_genre.id]
    end
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie, notice: "Movie successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy()
    redirect_to movies_url, status: :see_other, notice: "Movie successfully deleted"
  end

  private
    def movie_params
      params.require(:movie).permit(
        :name,
        :description,
        :rating,
        :released_on,
        :total_gross,
        :director,
        :duration,
        :image_file_name,
        genre_ids: []
      )
    end
end
