class MoviesController < ApplicationController
    SORT_COLUMNS = { "title" => :title, "release_date" => :release_date }.freeze
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @all_ratings = Movie.all_ratings
    form_submitted = params[:filters_submitted].present? || params[:sort_by].present?

    @ratings_to_show =
      if params[:ratings].present?
        params[:ratings].keys & @all_ratings
      elsif form_submitted
        @all_ratings
      else
        session[:ratings] || @all_ratings
      end
    @ratings_to_show = @all_ratings if @ratings_to_show.empty?

    requested_sort = params[:sort_by] || session[:sort_by]
    @sort_by = SORT_COLUMNS.key?(requested_sort) ? requested_sort : "title"

    session[:ratings] = @ratings_to_show
    session[:sort_by] = @sort_by

    @movies = Movie.with_ratings(@ratings_to_show).order(SORT_COLUMNS[@sort_by])
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @movie.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @movie.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end
