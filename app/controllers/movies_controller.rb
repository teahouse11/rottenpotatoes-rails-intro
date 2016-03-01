class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @all_ratings= ['G','PG','PG-13','R']
    @chosen_ratings=['G','PG','PG-13','R']
    # if(params[:ratings].present?)
    #   @chosen_ratings=params[:ratings]
    # end
    
    condition=params[:sort]
    
    if(condition.present?)
      flash[:notice] = "#{condition} was successfully created."
    else
      flash[:notice] = "nothing was successfully created."
    end
    if condition == "title"
      @movies=Movie.where(rating: @chosen_ratings).order("title")
      # @movies=Movie.order("title",)
      
    elsif condition == "date"
      @movies=Movie.where(rating: @chosen_ratings).order("release_date").reverse_order
      #@movies=Movie.order("release_date DESC")
    else
      @movies=Movie.where(rating: @chosen_ratings).order("release_date").reverse_order
      #@movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  
end
