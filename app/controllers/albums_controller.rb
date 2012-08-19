class AlbumsController < ApplicationController
  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.all
    #Setting a default value for the params[:sort]
    if params[:sort].blank? or not Album.column_names.include? params[:sort]
      params[:sort] = "created_at"
    end
    #Inserting values by each case: Name, Date, (Soon: By Alphabet!)
    if params[:sort] == "name"
      @sorted = @albums.sort! { |a,b| a.name.downcase <=> b.name.downcase }
      @title = "Name"      
    end
    if params[:sort] == "releasedate"
      @sorted = @albums.sort! { |a,b| b.releasedate.to_s <=> a.releasedate.to_s }  
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
    
    @album
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
    @pub = @album.publisher
    @title = "edit"
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new(params[:album])
    @artists = params["composers"] | params["arrangers"] | params["performers"]
    @artists.each do |artist|
      if artist.empty? == false
        @exists = Artist.find_by_name(artist)
        if @exists.nil?
          @artist = Artist.new(:name => artist)
          @artist.save
        end
      end
    end
    #Creating Relationships
    params["composers"].each do |each|
      if each.empty? == false
        @album.composers << Artist.find_by_name(each)
      end
    end
    params["arrangers"].each do |each|
      if each.empty? == false
        @album.arrangers << Artist.find_by_name(each)
      end
    end    
    params["performers"].each do |each|
      if each.empty? == false
        @album.performers << Artist.find_by_name(each)
      end
    end
    params["sources"].each do |each|
      if each.empty? == false
        @exists = Source.find_by_name(each)
        if @exists.nil?
          @album.sources.build(:name => each)
        else
          @album.sources << Source.find_by_name(each)
        end
      end
    end
    @publisher = params["Publisher"]["Name"]
      if @publisher.empty? == false
        @exists = Publisher.find_by_name(@publisher)
        if @exists.nil?
          @album.create_publisher!(:name => @publisher)
        else
          @album.publisher_id = @exists.id
        end
      end     

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, :notice => 'Album was successfully created.' }
        format.json { render :json => @album, :status => :created, :location => @album }
        if params[:title] == "new" or params[:title] == "screenscrape"
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
    @artists = params["composers"] | params["arrangers"] | params["performers"]
    @artists.each do |artist|
      if artist.empty? == false
        @exists = Artist.find_by_name(artist)
        if @exists.nil?
          @artist = Artist.new(:name => artist)
          @artist.save
        end
      end
    end    
    params["composers"].each do |each|
      if each.empty? == false
        @album.composers << Artist.find_by_name(each)
      end
    end
    params["arrangers"].each do |each|
      if each.empty? == false
        @album.arrangers << Artist.find_by_name(each)
      end
    end    
    params["performers"].each do |each|
      if each.empty? == false
        @album.performers << Artist.find_by_name(each)
      end
    end
    params["sources"].each do |each|
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
        @album.performers.delete(Artist.find_by_name(each.name))
      end
    end
    @exists = @album.sources.dup
    @exists.each do |each|
      @existence = each.name #setting an instance variable as 'each' name
      if params[@existence] == "0" #checking the value of params[each.name] (which was set to 0 when unchecked.)
        @album.sources.delete(Source.find_by_name(each.name))
      end
    end
    if @album.publisher.nil? == false
      @exists = @album.publisher.dup
      @existence = @exists.name #setting an instance variable as 'each' name
      if params[@existence] == "0" #checking the value of params[each.name] (which was set to 0 when unchecked.)
        @album.publisher_id = ""
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
  
  def websitelink
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @albums }
    end
  end
  def scrape
    @url = params['Website']['link']
    
    respond_to do |format|
      format.html { redirect_to scrapeanalbum_url :website => @url }
      format.json { head :no_content }
    end
  end
  def scrapeanalbum
    require 'open-uri'
    @title = "screenscrape"
    
    url = params[:website]
    doc = Nokogiri::HTML(open(url))
    #Name
    @name = doc.xpath("//span[@class='albumtitle']").first.text.chomp(" ")
    #Catalog Number
    @catalognumber = doc.xpath("//table[@id='album_infobit_large']//tr[1]//td[2]").text.split(' ')[0].chomp(" ")
    #Date
    @date = doc.xpath("//table[@id='album_infobit_large']//tr[2]//td[2]").text
    @datenum = Date.parse @date
    @dateyear = @datenum.year
    @datemonth = @datenum.month
    @dateday = @datenum.day
    #Genre
    @genre = doc.xpath("//td[@id='rightcolumn']/div[2]//div[@class='smallfont']//div[4]/text()").text.strip
    if @genre == "Animation"
      @genre = "Anime"
    end
    if @genre != "Anime" or @genre != "Game"
      @genre = ""
    end
    #Classification    Original or Arrangement
    #@classification = doc.xpath("//table[@id='album_infobit_large']//tr[6]//td[2]").text.split(", ")[0]
    #Reference
    @reference = url
    #Album Art
    @scrapedalbumartlink = doc.xpath("//img[@id= 'coverart']//@src").text
    if @scrapedalbumartlink == "http://media.vgmdb.net/img/album-nocover-medium.gif"
      @albumart = ""
    else
      @strippedname = @name.gsub("/", "").gsub("\"", "").gsub("|", "").gsub("?", "").gsub("*", "").gsub(":", "").gsub("#", "")
      @albumartlink = "http://vgmdb.net" + @scrapedalbumartlink
      open('app/assets/images/albumart/' + @strippedname + ".jpg", 'wb') do |file|
        file << open(@albumartlink).read
      @albumart = @name.gsub("/", "").gsub("\"", "").gsub("|", "").gsub("?", "").gsub("*", "").gsub(":", "").gsub("#", "") + ".jpg"
      end
    end
    #Publisher
    @publisher = doc.xpath("//table[@id='album_infobit_large']//tr[7]//td[2]/a[1]/span[1]").text.chomp(" ")
    #Composers  
    @scrapedcomposerlist = doc.xpath("//table[@id='album_infobit_large']//tr[8]//td[2]/text()").text.split(", ")
    @scrapedcomposer = @scrapedcomposerlist.reject { |arr| arr.all?(&:blank?)}
    @scrapedcomposers = []
    @scrapedcomposer.each do |each|
      @scrapedcomposers.push(each.chomp(" "))
    end
    @linkedcomposers = []
    doc.xpath("//table[@id='album_infobit_large']//tr[8]//td[2]//span[1]").each {|node|
      @linkedcomposers.push(node.text.chomp(" "))
      }
    doc.xpath("//table[@id='album_infobit_large']//tr[8]//td[2]/a/text()").each {|node|
      @linkedcomposers.push(node.text.chomp(" "))
      }   
    #Arrangers
    @scrapedarrangerlist = doc.xpath("//table[@id='album_infobit_large']//tr[9]//td[2]/text()").text.split(", ")
    @linkedarrangers = []
    @scrapedarranger = @scrapedarrangerlist.reject { |arr| arr.all?(&:blank?)}
    @scrapedarrangers = []
    @scrapedarranger.each do |each|
      @scrapedarrangers.push(each.chomp(" "))
    end
    doc.xpath("//table[@id='album_infobit_large']//tr[9]//td[2]//span[1]").each {|node|
      @linkedarrangers.push(node.text.chomp(" "))
      }
    doc.xpath("//table[@id='album_infobit_large']//tr[9]//td[2]/a/text()").each {|node|
      @linkedarrangers.push(node.text.chomp(" "))
      }   
    #APerformers
    @linkedperformers = []
    @scrapedperformerlist = doc.xpath("//table[@id='album_infobit_large']//tr[10]//td[2]/text()").text.split(", ")
    @scrapedperformer = @scrapedperformerlist.reject { |arr| arr.all?(&:blank?)}
    @scrapedperformers = []
    @scrapedperformer.each do |each|
      @scrapedperformers.push(each.chomp(" "))
    end
    doc.xpath("//table[@id='album_infobit_large']//tr[10]//td[2]//span[1]").each {|node|
      @linkedperformers.push(node.text.chomp(" "))
      }
    doc.xpath("//table[@id='album_infobit_large']//tr[10]//td[2]/a/text()").each {|node|
      @linkedperformers.push(node.text.chomp(" "))
      }    
    #Sources
    @scrapedsource = doc.xpath("//td[@id='rightcolumn']/div[2]//div[@class='smallfont']//div[5]/text()").text.split(", ")
    @scrapedsources = []
    @scrapedsource.each do |each|
      @scrapedsources.push(each.chomp(" "))
    end
    doc.xpath("//td[@id='rightcolumn']/div[2]//span[@class='productname'][1]").each {|node|
      @scrapedsources.push(node.text.chomp(" "))
      }
    @album = Album.new :name => @name, :releasedate => @datenum, :catalognumber => @catalognumber, :genre => @genre, :reference => @reference, :albumart => @albumart
    
    respond_to do |format|
      format.html # scrape!
      format.json { render :json => @album }
      format.js {}
    end
  end
  
end
