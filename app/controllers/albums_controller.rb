class AlbumsController < ApplicationController
  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.all
    #Setting a default value for the params[:sort]
    if params[:sort].blank? or not Album.column_names.include? params[:sort]
      params[:sort] = "releasedate"
    end
    #Inserting values by each case: Name, Date, (Soon: By Alphabet!)
    if params[:sort] == "name"
      @sorted = @albums.sort! { |a,b| a.name.downcase <=> b.name.downcase }
      @title = "Name"      
    end
    if params[:sort] == "releasedate"
      @sorted = @albums.sort! { |a,b| b.releasedate <=> a.releasedate }  
      @title = "Release Date"
    end
    if params[:sort] == "created_at"
      @sorted = @albums.sort! { |a,b| b.created_at <=> a.created_at }  
      @title = "Added Date"
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    @album = Album.find(params[:id])
    @composers = @album.composers
    @arrangers = @album.arrangers
    @performers = @album.performers
    @sources = @album.sources
    @publisher = @album.publisher
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @album }
    end
  end

  # GET /albums/new
  # GET /albums/new.json
  def new
    @album = Album.new
    @title = "new"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @album }
      format.js {}
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
    @composers = @album.composers
    @arrangers = @album.arrangers
    @performers = @album.performers
    @sources = @album.sources
    @publisher = @album.publisher
    @title = "edit"
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new(params[:album])
    
    #Creating Relationships
    params["Composer Names"].each do |each|
      if each.empty? == false
        @exists = Artist.find_by_name(each)
        if @exists.nil? == true
          @album.composers.build(:name => each)
        else
          @album.composers << Artist.find_by_name(each)
        end
      end
    end
    params["Arranger Names"].each do |each|
      if each.empty? == false
        @exists = Artist.find_by_name(each)
        if @exists.nil? == true
          @album.arrangers.build(:name => each)
        else
          @album.arrangers << Artist.find_by_name(each)
        end
      end
    end    
    params["Performer Names"].each do |each|
      if each.empty? == false
        @exists = Artist.find_by_name(each)
        if @exists.nil? == true
          @album.performers.build(:name => each)
        else
          @album.performers << Artist.find_by_name(each)
        end
      end
    end
    params["Source Names"].each do |each|
      if each.empty? == false
        @exists = Source.find_by_name(each)
        if @exists.nil? == true
          @album.sources.build(:name => each)
        else
          @album.sources << Source.find_by_name(each)
        end
      end
    end
    @publisher = params["Publisher"]["Name"]
      if @publisher.empty? == false
        @exists = Publisher.find_by_name(@publisher)
        if @exists.nil? == true
          @album.create_publisher!(:name => @publisher)
        else
          @album.publisher_id = @exists.id
        end
      end     

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, :notice => 'Album was successfully created.' }
        format.json { render :json => @album, :status => :created, :location => @album }
        if params[:title] == "new"
          format.js { js_redirect_to(album_path(@album))}
        else
          format.js {}           
        end
      else
        format.html { render :action => "new" }
        format.json { render :json => @album.errors, :status => :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PUT /albums/1
  # PUT /albums/1.json
  def update
    @album = Album.find(params[:id])
    
   #Creating Relationships
    params["Composer Names"].each do |each|
      if each.empty? == false
        @exists = Artist.find_by_name(each)
        if @exists.nil? == true
          @album.composers.build(:name => each)
        else
          @album.composers << Artist.find_by_name(each)
        end
      end
    end
    params["Arranger Names"].each do |each|
      if each.empty? == false
        @exists = Artist.find_by_name(each)
        if @exists.nil? == true
          @album.arrangers.build(:name => each)
        else
          @album.arrangers << Artist.find_by_name(each)
        end
      end
    end    
    params["Performer Names"].each do |each|
      if each.empty? == false
        @exists = Artist.find_by_name(each)
        if @exists.nil? == true
          @album.performers.build(:name => each)
        else
          @album.performers << Artist.find_by_name(each)
        end
      end
    end
    params["Source Names"].each do |each|
      if each.empty? == false
        @exists = Source.find_by_name(each)
        if @exists.nil? == true
          @album.sources.build(:name => each)
        else
          @album.sources << Source.find_by_name(each)
        end
      end
    end    
    @publisher = params["Publisher"]["Name"]
      if @publisher.empty? == false
        @exists = Publisher.find_by_name(@publisher)
        if @exists.nil? == true
          @album.create_publisher!(:name => @publisher)
        else
          @album.publisher_id = @exists.id
        end
      end  
    
    #Deleting Relationships  
    @exists = @album.composers.dup
    @exists.each do |each|
      @existence = each.name #setting an instance variable as 'each' name
      if params[@existence] == "0" #checking the value of params[each.name] (which was set to 0 when unchecked.)
        @album.composers.delete(Artist.find_by_name(each.name))
      end
    end    
    @exists = @album.arrangers.dup
    @exists.each do |each|
      @existence = each.name #setting an instance variable as 'each' name
      if params[@existence] == "0" #checking the value of params[each.name] (which was set to 0 when unchecked.)
        @album.arrangers.delete(Artist.find_by_name(each.name))
      end
    end    
    @exists = @album.performers.dup
    @exists.each do |each|
      @existence = each.name #setting an instance variable as 'each' name
      if params[@existence] == "0" #checking the value of params[each.name] (which was set to 0 when unchecked.)
        @album.arrangers.delete(Artist.find_by_name(each.name))
      end
    end
    @exists = @album.sources.dup
    @exists.each do |each|
      @existence = each.name #setting an instance variable as 'each' name
      if params[@existence] == "0" #checking the value of params[each.name] (which was set to 0 when unchecked.)
        @album.sources.delete(Source.find_by_name(each.name))
      end
    end  

    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to @album, :notice => 'Album was successfully updated.' }
        format.json { head :no_content }
        format.js { js_redirect_to(album_path(@album))}
      else
        format.html { render :action => "edit" }
        format.json { render :json => @album.errors, :status => :unprocessable_entity }
        format.js {}
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :no_content }
    end
  end
end
