class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def js_redirect_to(path)
    render :js => "window.location.replace('#{path}');" and return
  end
  
  def pagination_function(item, type, itemsperpage)
    if type == 'alphabetical'
    
    else      
      p = item.paginate(:page => params[:page], :per_page => itemsperpage)
    end
  end
  
#  def filter_function(instance, model, filterparam)
    # Explanation of inputs
    # Instance: The instance list of the model
    #   @albums, @sources, @artists, @publishers
    # model: The resource the function is working in
    #   Album, Source, 
    # filterlist: The list of parameters to filter out
    #
    # default: The default filtering behavior
    #
#    if filterparam.blank?
#      filterparam =  []
#    end
#  end
  
  def filter_function(item, model, filterattribute, filteroptions, default)  
    #Default Filtering
    if filterattribute.blank?
      filterattribute = default
    end    
    #Output (case by case basis, since each filter is unique)
    @filteritem = item
    if filterattribute == "No Filter"
      blacklist = []
      @filtered = @filteritem.reject { |h| blacklist.include? h['database_activity']}
    end
    if filterattribute == "Ignored"
      blacklist = ["Ignored"]
      @filtered = @filteritem.reject { |h| blacklist.include? h['database_activity']}
    end
    if filterattribute == "Low Priority"
      blacklist = ["Ignored", "Low Priority"] 
      @filtered = @filteritem.reject { |h| blacklist.include? h['database_activity']}
    end 
    if filterattribute == "Anime"
      blacklist = []
      whitelist = ["Anime"]
      @filteritem = @filteritem.select { |h| whitelist.include? h['genre'] }  
      @filtered = @filteritem.reject { |h| blacklist.include? h['genre']}    
    end
    if filterattribute == "Unobtained"
      blacklist = ['true']
      @filtered = @filteritem.reject { |h| blacklist.include? h['obtained']}    
    end
    if filterattribute == "Only Watched"
      blacklist = ["Ignored", "Low Priority"]
      whitelist = ["Up to Date", "Not Up to Date"]
      @filteritem = @filteritem.select { |h| whitelist.include? h['database_activity'] }
      @filtered = @filteritem.reject { |h| blacklist.include? h['database_activity']}
    end
    #Take out the filter option from the filter list
    filteroptions.delete(filterattribute)
    @filterlist = filteroptions  
  end
  
  def sort_function(item, model, sortattribute, sortlist, default)
    #Default Sorting
    if sortattribute.blank? or not model.column_names.include? sortattribute
      sortattribute = default
    end
    #Function for changing attributes to more consumer friendly names
    def layman(word)
      if word == "name"
        @attributetitle = "Name"
      end
      if word == "database_activity"
        @attributetitle = "Database Activity"
      end
      if word == "activity"
        @attributetitle = "Activity"
      end
      if word == "created_at"
        @attributetitle = "Added Date"
      end
      if word == "releasedate"
        @attributetitle = "Release Date"
      end
      if word == "publisher"
        @attributetitle = "Publisher"
      end
    end
    #Output (Direction is defined here)
    if sortattribute == "name"
      @sorted = item.sort! { |a,b| a.send(sortattribute.to_sym).to_s.downcase <=> b.send(sortattribute.to_sym).to_s.downcase }
    else
      @sorted = item.sort! { |a,b| b.send(sortattribute.to_sym).to_s.downcase <=> a.send(sortattribute.to_sym).to_s.downcase }
    end
    #Take out the sorted attribute from the sort list
    sortlist.delete(sortattribute)
    sortarray = []
    sortlist.each do |attribute|
      layman(attribute)
      sortarray << [attribute, @attributetitle]
    end
    @sortlist = sortarray
    layman(sortattribute)
    @sorttitle = @attributetitle
  end
  
  def adding_self_reference_function(resource, instance, childparam, objectid)
    # Explanation of Parameters
    # resource: The resource the function is working in.
    #   Artist, Album, Source, etc.
    # instance: Instance variable of the resource along with the model method
    #   @artist.units
    # childparam: 
    #   :member, :alias, etc.
    # id: The child id
    #   :member_id 
    if params[childparam][:name].to_s.empty? == false
      @child = resource.find_by_name(params[childparam][:name])
      if @child.nil? == false
        instance.build(objectid => @child.id).save
      else
        @newchild = resource.new(params[childparam])
        @newchild.save
        instance.build(objectid => @newchild.id).save
      end
    end
  end
  
  def deleting_self_reference_function(resource, instance, model, attr_id_str, objectid)
    # Explanation of parameteres
    # resource:
    #   Artist, Album, Source, etc.
    # instance
    #   @artist.units, @artist.aliases, etc.
    # model
    #   Unit, Alias
    # attribute_id_str: String representation of the object's id
    #   "member_id"
    # objectid
    #   :object_id
    @listdup = instance.dup
    @listdup.each do |each|
      @id =  each.attributes[attr_id_str]
      @exists = resource.find_by_id(@id).name
      if params[@exists] == "0"
        @delete = model.where(objectid => @id).first
        @delete.delete.save
      end
    end
  end
end
