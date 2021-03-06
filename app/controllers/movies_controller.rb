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
    @all_ratings= ['G','PG','PG-13','R']
    @chosen_ratings=['G','PG','PG-13','R']
    if(params[:ratings].present?)
      @chosen_ratings= params[:ratings].keys
      session[:current_ratings]=@chosen_ratings
    else
        if(session[:current_ratings].present?)
          @chosen_ratings=session[:current_ratings]
        else
          session[:current_ratings]=@chosen_ratings
        end
    end
    @condition="title"
    if(params[:sort].present?)
      @condition=params[:sort]
      session[:current_sort]=@condition
    else
        if(session[:current_sort].present?)
          @condition=session[:current_sort]
        end
    end
    if @condition == "title"
      @movies=Movie.where(rating: @chosen_ratings).order("title")
      @style_t="hilite"
    elsif @condition == "date"
      @movies=Movie.where(rating: @chosen_ratings).order("release_date").reverse_order
      @style_d="hilite"
    else
      @movies=Movie.where(rating: @chosen_ratings).order("release_date").reverse_order
      @style_t=""
      @style_d=""
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
