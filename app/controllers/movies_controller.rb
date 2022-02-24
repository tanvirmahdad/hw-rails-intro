class MoviesController < ApplicationController
    
    @@visitCount=0

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      
      
      
      @@visitCount +=1;
      @instanceCount=@@visitCount
      
      #logger.debug " hash: #{request.env["HTTP_REFERER"].inspect}"
      
      if(params[:sort])
        session[:sort]=params[:sort]
      elsif (@instanceCount==1)
        session[:sort].clear
      #else
        #params[:sort]=session[:sort]
        #redirect_to action
        #flash.keep
        #redirect_to controller: 'movies', action: 'index' && return
      end
      
      @movParam=session[:sort]
      @all_ratings=Movie.ratingRetriver
      #logger.debug " hash: #{@all_ratings.inspect}"
      
      
      
      if(params[:ratings])
        session[:ratings]=params[:ratings]
      elsif (@instanceCount==1)
        session[:ratings]=nil
      end
      
      
     
    
      if(session[:ratings])
        #@movies = Movie.where("rating IN (?)", params[:ratings].keys).order(params[:sort])
        @movies=Movie.with_ratings(session[:ratings].keys).order(session[:sort])
        @is_rating_present=session[:ratings]
        #logger.debug " hash: #{params[:ratings].inspect}"
        #logger.info "Hey I am here"
      else
        @movies = Movie.order(session[:sort])
        @is_rating_present=[]
      end
      
      if !(params[:sort]) || (params[:ratings]==nil)
        params[:sort]=session[:sort]
        params[:ratings]=session[:ratings]
        redirect_to controller: 'movies', action: 'index', sort: params[:sort], "utf8": "✓", "ratings": (params[:ratings])? params[:ratings].to_unsafe_h : {"G"=>"G", "R"=>"R", "PG-13"=>"PG-13", "PG"=>"PG"}
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end