class ArtistsController < ApplicationController
  # GET /artists
  # GET /artists.json
  
  # List of Methods:
  #   Index:
  #   Show:
  #   New:
  #   Edit:
  #   Create:
  #   Update:
  #   Destroy:
  # Related Classes:
  #   Album:
  #   Unit:
  #   Alias:
  
   
  def index 
    @artists = Artist.all
    
    #Step 1: Filtering!
    @masterfilterlist = ['No Filter', 'Ignored', 'Low Priority', 'Only Watched']
    filter_function(@artists, Artist, params[:filter], @masterfilterlist, 'No Filter')
    #Step 2: Sorting!
    @mastersortlist = ['name', 'activity', 'database_activity']
    sort_function(@filtered, Artist, params[:sort], @mastersortlist, 'name')
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @artists }
    end
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
    @artist = Artist.find(params[:id])
    @albumbycomposers = @artist.albumbycomposers
    @albumbyarrangers = @artist.albumbyarrangers
    @albumbyperformers = @artist.albumbyperformers
    @albums = @albumbyarrangers | @albumbycomposers | @albumbyperformers
    #For Showing Aliases
    @aliases = @artist.aliases
    @parentalias = Alias.find_by_alias_id(@artist.id) #For showing Parents
    if @parentalias.nil? == false
      @parent = Artist.find_by_id(@parentalias[:parent_id])
    end 
    #For Showing Units
    @members = @artist.units
    @units= @artist.inverse_units
    #Code for Obtained Functionality
    @artist.obtained = true
    @albums.each do |each|
      if each.obtained == false
        @artist.obtained = false
      end
    end
    @artist.save
    
    #For adding an Album under an Artist
    @album = Album.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @artist }
      format.js {}
    end
  end

  # GET /artists/new
  # GET /artists/new.json
  def new
    @artist = Artist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @artist }
    end
  end

  # GET /artists/1/edit
  def edit
    @artist = Artist.find(params[:id])
    @aliases = @artist.aliases
    @members = @artist.units
    @title = "edit"
  end

  # POST /artists
  # POST /artists.json
  def create
    @artist = Artist.new(params[:artist])

    respond_to do |format|
      if @artist.save
        format.html { redirect_to @artist, :notice => 'Artist was successfully created.' }
        format.json { render :json => @artist, :status => :created, :location => @artist }
      else
        format.html { render :action => "new" }
        format.json { render :json => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /artists/1
  # PUT /artists/1.json
  def update
    @artist = Artist.find(params[:id])
    
    #Deleting an Alias Association
    @aliasesdup = @artist.aliases.dup
    @aliasesdup.each do |each|
      @existence = Artist.find_by_id(each.alias_id).name
      if params[@existence] == "0"
        @aliasdel = Alias.find_by_alias_id(each.alias_id)
        @aliasdel.delete.save
      end
    end
    #Creating An Alias Association
    adding_self_reference_function(Artist, @artist.aliases, :alias, :alias_id)
    #Deleting a Unit Association
    @unitsdup = @artist.units.dup
    @unitsdup.each do |each|
      @existence = Artist.find_by_id(each.member_id).name
      if params[@existence] == "0"
        @memberdel = Unit.find_by_member_id(each.member_id)
        @memberdel.delete.save
      end
    end
    #Creating a Unit Association
    adding_self_reference_function(Artist, @artist.units, :member, :member_id)

    respond_to do |format|
      if @artist.update_attributes(params[:artist])
        format.html { redirect_to @artist, :notice => 'Artist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @artist = Artist.find(params[:id])
    @artist.units.clear
    @
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to artists_url }
      format.json { head :no_content }
    end
  end
end
