class RendersController < ApplicationController
   class InfoFeed
     attr_accessor :id, :name, :email, :portrait, :script, :image_url, :created_at, :good_num, :bad_num, :comment_num, :collected
     def initialize(email, portrait, id, name, script, image_url, created_at, good_num, bad_num, comment_num, collected)
       @email = email
       @portrait = portrait
       @id = id
       @name = name
       @script = script
       @image_url = image_url
       @created_at = created_at
       @good_num = good_num
       @bad_num = bad_num
       @comment_num = comment_num
       @collected = collected
     end
   end 

   def home
      @episode_feed_items = Episode.paginate(:page => params[:page], :per_page => 2);
      @feed_items = []
      user = current_user
      @episode_feed_items.each do |item|
        collected = false
        if signed_in?
          tmp_ = Collection.where(:user_id=>user.id, :episode_id=>item.id)
          if tmp_.length != 0
            collected = true
          else
            collected = false
          end
        else
          collected = false
        end
        user = User.find_by_name(item.name)
        infoFeed = InfoFeed.new(user.email, user.portrait, item.id, item.name, item.script, 
             item.image_url, item.created_at, item.good_num,
             item.bad_num, item.comment_num, collected)
        @feed_items.push(infoFeed)
      end
    end

    def sort
    if params[:sort]=="hot"
      @episode_feed_items = Episode.order("good_num DESC, bad_num ASC, comment_num DESC").paginate(:page => params[:page], :per_page => 2)
      @feed_items = []
      @episode_feed_items.each do |item|
        user = User.find_by_name(item.name);
        collected = false;
        len = Collection.where(:user_id=>user.id, :episode_id=>item.id)
        if len.length > 0
          collected = true
        else
          collected = false
        end 
        infoFeed = InfoFeed.new(user.email, user.portrait,item.id, item.name, item.script, 
        item.image_url, item.created_at, item.good_num,
        item.bad_num, item.comment_num, collected)
        @feed_items.push(infoFeed)
      end
      respond_to do |format|
        format.html
        format.js
      end 
    elsif params[:sort]=="last"
      @episode_feed_items = Episode.paginate(:page => params[:page], :per_page => 2)
      @feed_items = []
      @episode_feed_items.each do |item|
        user = User.find_by_name(item.name);
        collected = false;
        len = Collection.where(:user_id=>user.id, :episode_id=>item.id)
        if len.length > 0
          collected = true
        else
          collected = false
        end 
        infoFeed = InfoFeed.new(user.email, user.portrait,item.id, item.name, item.script, 
        item.image_url, item.created_at, item.good_num,
        item.bad_num, item.comment_num, collected)
        @feed_items.push(infoFeed)
      end
      respond_to do |format|
        format.html
        format.js
      end
    else
      @episode_feed_items = Episode.paginate(:page => params[:page], :per_page => 2)
      @feed_items = []
      @episode_feed_items.each do |item|
        user = User.find_by_name(item.name);
        collected = false;
        len = Collection.where(:user_id=>user.id, :episode_id=>item.id)
        if len.length > 0
          collected = true
        else
          collected = false
        end 
        infoFeed = InfoFeed.new(user.email, user.portrait, item.id, item.name, item.script, 
        item.image_url, item.created_at, item.good_num,
        item.bad_num, item.comment_num, collected)
        @feed_items.push(infoFeed)
      end
    end
  end
   
  def estimate
    @id = params[:id]
    @es = params[:es]
    @flag = 0
    @num = 0
    if !signed_in?
      @flag = -1
    elsif hasMadeEstimate?(@id.to_i, current_user.id)
      @flag = 1
    else
      episode = Episode.find(@id.to_i)
      if @es == "good"
        episode.good_num = episode.good_num + 1
        @num = episode.good_num
      else
        episode.bad_num = episode.bad_num + 1
        @num = episode.bad_num
      end
      episode.save
      Estimate.new(:episode_id=>@id.to_i, :user_id=>current_user.id).save
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  #respond_to do |format|
  #  res = {:num => num}
  #  format.json {render :json=>res}
  #end 

  class CommentFeed
    attr_accessor :id, :episode_id, :name, :content, :created_at, :email, :portrait

    def initialize(id, episode_id, name, content, created_at, email, portrait)
      @id = id
      @episode_id = episode_id
      @name = name
      @content = content
      @created_at = created_at
      @email = email
      @portrait = portrait
    end
  end

  def dashboard
    @episode_id = params[:episode_id]
    episode = Episode.find(@episode_id)
    collected = false
    user = current_user
    if signed_in?
      tmp_ = Collection.where(:user_id=>user.id, :episode_id=>@episode_id)
      if tmp_.length != 0
        collected = true
      else
        collected = false
      end
    else
      collected = false
    end
    episode_owner = User.find_by_name(episode.name)
    @feed_item = InfoFeed.new(episode_owner.email, episode_owner.portrait, @episode_id, episode.name, episode.script,
        episode.image_url, episode.created_at, episode.good_num,
        episode.bad_num, episode.comment_num, collected)
    @all_comments = []
    Comment.all.each do |com|
      if "#{com.episode_id}" == @episode_id
        id = com.id
        episode_id = com.episode_id
        name = com.name
        content = com.content
        created_at = com.created_at
        tmp_user = User.find_by_name(name)
        email = tmp_user.email
        portrait = tmp_user.portrait
        tmp_comment_feed_object = CommentFeed.new(id, episode_id, name, content, created_at, email, portrait)
        @all_comments.push(tmp_comment_feed_object)
      end
    end
  end

  def produce
    if signed_in?
    episode_id = params[:episode_id]
    content = params[:comment][:content]
    user_ = current_user
    name = user_.name
    comment_ = Comment.new({:episode_id=>episode_id, :name=>name ,:content=>content})
    tmp1 = comment_.save
    @comment = CommentFeed.new(comment_.id, episode_id, name, content, comment_.created_at, user_.email, user_.portrait)
    @episode = Episode.find(episode_id)
    @episode.comment_num = @episode.comment_num + 1
    tmp2 = @episode.save
    respond_to do |format|
      if tmp1 && tmp2
        format.html {render :action=>"dashboard"}
        format.js
      else
        format.html {render :action=>"dashboard"}
        format.js
      end
    end
    else
     respond_to do |format|
      format.html {render :action=>"dashboard"}
      format.js
     end
    end
  end

end
