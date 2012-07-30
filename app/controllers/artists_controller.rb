class ArtistsController < ApplicationController
  # GET /artists
  # GET /artists.json
  def index 
    @artists = Artist.all   
    #Filtering Code
    if params[:filter].blank?
      params[:filter] = "nofilter"
    end        
    if params[:filter] == "nofilter"
      blacklist = []
    end    
    if params[:filter] == "filterignored"
      blacklist = ["Ignored"]     
    end    
    if params[:filter] == "filterlowpriority"
      blacklist = ["Ignored", "Low Priority"]     
    end
    #Sorting Code
    @filteredartists = @artists.reject { |h| blacklist.include? h['database_activity']}
    @artistssorted = @filteredartists.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    
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
    @unitmember = Unit.find_by_member_id(@artist.id) #For Showing Units
    if @unitmember.nil? == false
      @unit = Artist.find_by_id(@unitmember[:unit_id])
    end
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
    if params[:alias][:name].to_s.empty? == false
      @alias = Artist.find_by_name(params[:alias][:name])
      if @alias.nil? == false
        @artist.aliases.build(:alias_id => @alias.id).save
      else
        @aliasnew = Artist.new(params[:alias])
        @aliasnew.save
        @artist.aliases.build(:alias_id => @aliasnew.id).save
      end
    end
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
    if params[:member][:name].to_s.empty? == false
      @member = Artist.find_by_name(params[:member][:name])
      if @member.nil? == false
        @artist.units.build(:member_id => @member.id).save
      else
        @membernew = Artist.new(params[:unit])
        @membernew.save
        @artist.units.build(:member_id => @membernew.id).save
      end
    end

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
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to artists_url }
      format.json { head :no_content }
    end
  end
end
