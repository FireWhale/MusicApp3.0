class SourcesController < ApplicationController
  # GET /sources
  # GET /sources.json
  def index
    @sources = Source.all
    @sourcessorted = @sources.sort! { |a,b| a.name.downcase <=> b.name.downcase }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @sources }
    end
  end

  # GET /sources/1
  # GET /sources/1.json
  def show
    @source = Source.find(params[:id])
    @albums = @source.albums
    #Code for Obtained Functionality
    @source.obtained = true
    @albums.each do |each|
      if each.obtained == false
        @source.obtained = false
      end
    end
    @source.save
    #For showing Franchises/Instances
    @instances = @source.franchises
    @franchiserecord = Franchise.find_by_instance_id(@source.id) #For showing Parents
    if @franchiserecord.nil? == false
      @franchise = Source.find_by_id(@franchiserecord[:franchise_id])
    end 
    #For adding an Album under an Artist
    @album = Album.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @source }
      format.js {}
    end
  end

  # GET /sources/new
  # GET /sources/new.json
  def new
    @source = Source.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @source }
    end
  end

  # GET /sources/1/edit
  def edit
    @source = Source.find(params[:id])
    @instances = @source.franchises
    @title = "edit"
  end

  # POST /sources
  # POST /sources.json
  def create
    @source = Source.new(params[:source])

    respond_to do |format|
      if @source.save
        format.html { redirect_to @source, :notice => 'Source was successfully created.' }
        format.json { render :json => @source, :status => :created, :location => @source }
      else
        format.html { render :action => "new" }
        format.json { render :json => @source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sources/1
  # PUT /sources/1.json
  def update
    @source = Source.find(params[:id])
    #Creating a franchise/instance association 
    adding_self_reference_function(Source, @source.franchises, :instance, :instance_id)
    #deleteing a franchise/instance association
    @dup = @source.franchises.dup
    @dup.each do |each|
      @existence = Source.find_by_id(each.instance_id).name
      if params[@existence] == "0"
        @del = Franchise.find_by_instance_id(each.instance_id)
        @del.delete.save
      end
    end
    
    respond_to do |format|
      if @source.update_attributes(params[:source])
        format.html { redirect_to @source, :notice => 'Source was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sources/1
  # DELETE /sources/1.json
  def destroy
    @source = Source.find(params[:id])
    @source.destroy

    respond_to do |format|
      format.html { redirect_to sources_url }
      format.json { head :no_content }
    end
  end
end
