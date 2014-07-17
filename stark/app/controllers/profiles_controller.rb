class ProfilesController < ApplicationController
	class UserContainer
		attr_accessor :name, :portrait, :email

		def initialize(name, portrait, email)
			@name = name
			@portrait = portrait
            @email = email
		end
    end

    class UserWrapper
        attr_accessor :name, :portrait, :email, :subscribed

        def initialize(user, subscribed)
            @name = user.name
            @portrait = user.portrait
            @email = user.email
            @subscribed = subscribed
        end
    end

	def index
	  name = params[:name]
	  @flag = 0
	  if signed_in?
        user___ = current_user
	  	your_name = user___.name
	  	if name == your_name || name == nil
	  		@flag = 2
	  		@user = UserWrapper.new(user___, -1)
        else
        	@flag = 1
        	user_ = User.find_by_name(name)
            subscribed = 1
            if Subscription.where(:active_id=>user___.id, :passive_id=>user_.id).length != 0
                subscribed = 0
            else
                subscribed = 1
            end
        	@user = UserWrapper.new(UserContainer.new(user_.name, user_.portrait, user_.email), subscribed)
	  	end
      else #access other's page
      	@flag = 0
      	user_ = User.find_by_name(name)
      	@user = UserWrapper.new(UserContainer.new(user_.name, user_.portrait, user_.email), 1)
      end
	end

	def modification
		if !signed_in?
			redirect_to signin_path
		end
		@user = current_user
	end

    def modify
    	name = params[:user][:name]
    	image_io = params[:user][:portrait]
    	@user = current_user
    	if image_io != nil 
    		image_name = @user.portrait
    		if image_name != nil
    		  image_url = Rails.root.join('public', 'images', image_name)
    		  File.delete(image_url)
    		  File.open(image_url, 'wb') do |file|
    			  file.write(image_io.read)
    		  end
    		else
    		  image_name = Time.new.to_s.split.join("-") + "-" + image_io.original_filename
    		  image_name = Digest::SHA1.hexdigest image_name
    		  image_url = Rails.root.join('public', 'images', image_name)
    		  File.open(image_url, 'wb') do |file|
                file.write(image_io.read)
              end
              @user.update_attribute(:portrait, image_name)
    	    end
    	end

    	if name != nil
    		@user.update_attribute(:name, name)
    	end

    	redirect_to profile_path
    end
    
    class HistoryInfo
        attr_accessor :name, :id, :script, :image_url, :created_at, :good_num, :bad_num, :comment_num, :authority

        def initialize(name, id, script, image_url, created_at, good_num, bad_num, comment_num, authority)
            @name = name
            @id = id
            @script = script
            @image_url = image_url
            @created_at = created_at
            @good_num = good_num
            @bad_num = bad_num
            @comment_num = comment_num
            @authority = authority
        end
    end

    def history
        name = params[:name]
        @user = current_user
        @authority = 0
        owner_user = User.find_by_name(name)
        setting = Setting.find_by_owner(owner_user.id)
        if signed_in? && @user.name == name
            @authority = 1
        elsif setting.history
            @authority = 0
        else
            @authority = -1
        end
        @all_history_episodes = []        
        all_episodes = Episode.where(:name=>name)
        all_episodes.each do |episode|
            statistic = Statistic.find(episode.id)
            @all_history_episodes.push(HistoryInfo.new(episode.name, episode.id, episode.script, episode.image_url, 
                episode.created_at, statistic.good_num, statistic.bad_num, statistic.comment_num, @authority))
        end
        respond_to do |format|
          format.html
          format.js
        end
    end

    def delete_history
        @name = params[:name]
        @id = params[:id]
        if signed_in? && current_user.name == @name
            Episode.find(@id).destroy
            Statistic.find(@id).destroy
            Comment.where(:episode_id=>@id).destroy_all
            respond_to do |format|
                format.html
                format.js
            end
        end
    end

    def collection
        @user = current_user
        if signed_in?
            @collections = Collection.where(:user_id=>@user.id)
            respond_to do |format|
                format.html
                format.js
            end
        end
    end

    def collect
        if signed_in?
          user = current_user
          @episode_id = params[:episode_id]
          episode = Episode.find(@episode_id)
          collection_ = Collection.new(:user_id=>user.id, :episode_id=>@episode_id, :writer_name=>episode.name, :script=>episode.script, :image_url=>episode.image_url, :time=>episode.created_at)
          collection_.save
          respond_to do |format|
            format.html
            format.js
          end
        else
            render :js=>"window.location.href='/signin'"
        end
    end

    def delete_collection
        @id = params[:id]
        user = current_user
        if signed_in?
            Collection.find(@id).destroy
            respond_to do |format|
                format.html
                format.js
            end
        else
            render :js=>"window.location.href='/signin'"
        end
    end

    class SubsFeed
        attr_accessor :user_id, :name

        def initialize(user_id, name)
            @user_id = user_id
            @name = name
        end
    end

    def subscription
        user = current_user
        if signed_in?
            @my_subscriptions = Subscription.where(:active_id=>user.id)
            @my_subscription_feeding_items = []
            @my_subscriptions.each do |subs|
                @my_subscription_feeding_items.push(SubsFeed.new(subs.passive_id, User.find(subs.passive_id).name))
            end
            respond_to do |format|
              format.html
              format.js
            end
        end
    end

    def subscribe
        name = params[:name]
        user = current_user
        if signed_in?
            if user.name != name
                Subscription.new(:active_id=>user.id, :passive_id=>User.find_by_name(name).id).save
                respond_to do |format|
                    format.html
                    format.js
                end
            end
        else
            render :js=>"window.location.href='/signin'"
        end
    end

    class UserFeeding
        attr_accessor :episode_id, :name, :portrait, :email, :script, :image_url, :good_num, :bad_num, :comment_num, :created_at, :collected

        def initialize(episode_id, name, portrait, email, script, image_url, good_num, bad_num, comment_num, created_at, collected)
            @episode_id = episode_id
            @name = name
            @portrait = portrait
            @email = email
            @script = script
            @image_url = image_url
            @good_num = good_num
            @bad_num = bad_num
            @comment_num = comment_num
            @created_at = created_at
            @collected = collected
        end
    end

    def feeding
        name = params[:name]
        id = params[:id]
        writer_name = name
        writer_portrait = User.find(id.to_i).portrait
        writer_email = User.find(id.to_i).email
        episodes = Episode.where(:name=>name)
        @all_user_feedings = []
        user = current_user
        if signed_in?
            episodes.each do |episode|
                collected = false
                tmp_ = Collection.where(:user_id=>user.id, :episode_id=>episode.id)
                if tmp_.length != 0
                  collected = true
                else
                  collected = false
                end
                episode_id = episode.id
                script = episode.script
                image_url = episode.image_url
                created_at = episode.created_at
                statistic = Statistic.find(episode_id)
                good_num = statistic.good_num
                bad_num = statistic.bad_num
                comment_num = statistic.comment_num
                @all_user_feedings.push(UserFeeding.new(episode_id, writer_name, writer_portrait, writer_email, script, image_url, good_num, bad_num, comment_num, created_at, collected))
            end
            respond_to do |format|
                format.html
                format.js
            end
        end
    end

    def cancel_subscription
        @passive_id = params[:id]
        user = current_user
        if signed_in?
            active_id = user.id
            Subscription.where(:active_id=>active_id, :passive_id=>@passive_id).destroy_all
            respond_to do |format|
                format.html
                format.js
            end
        end
    end

    class WhisperFeed
        attr_accessor :id, :email, :name, :portrait, :content, :created_at

        def initialize(id, email, name, portrait, content, created_at)
            @id = id
            @email = email
            @name = name
            @portrait = portrait
            @content = content
            @created_at = created_at
        end
    end

    def whisper
        @accessed_profile_owner_name = params[:name]
        user = current_user
        @flag = 0
        owner_user = User.find_by_name(@accessed_profile_owner_name)
        setting = Setting.find_by_owner(owner_user.id)
        if signed_in?
            if user.name == @accessed_profile_owner_name
                @flag = 1
                @whisper_items = Whisper.where(:owner=>user.id)
                @whisper_feeding_items = []
                @whisper_items.each do |item|
                    id = item.id
                    tmp_user = User.find(item.guest)
                    email = tmp_user.email
                    name = tmp_user.name
                    portrait = tmp_user.portrait
                    content = item.content
                    created_at = item.created_at
                    @whisper_feeding_items.push(WhisperFeed.new(id, email, name, portrait, content, created_at))
                end
            else
                if !setting.whisper
                    @flag = -1
                end
            end

            respond_to do |format|
                format.html
                format.js
            end
        else
            render :js=>'window.location.href="/signin"'
        end
    end

    def make_whisper
        content = params[:whisper][:content]
        accessed_profile_owner_name = params[:name]
        user = current_user
        if signed_in?
            guest = user.id
            owner = User.find_by_name(accessed_profile_owner_name).id
            if Whisper.new(:guest=>guest, :owner=>owner, :content=>content).save
                respond_to do |format|
                    format.html
                    format.js
                end
            end
        else
            render :js=>'window.location.href="/signin"'
        end
    end

    def make_reply
        @name_of_user_to_reply_to = params[:name]
        user = current_user
        if signed_in?
            id_of_user_to_reply_to = User.find_by_name(@name_of_user_to_reply_to).id
            owner = id_of_user_to_reply_to
            guest = user.id
            content = params[:whisper][:content]
            if Whisper.new(:guest=>guest, :owner=>owner, :content=>content).save
                respond_to do |format|
                    format.html
                    format.js
                end
            end
        else
            render :js=>'window.location.href="/signin"'
        end
    end

    def reply
        @name_of_user_to_reply_to = params[:name]
        user = current_user
        if signed_in?
            respond_to do |format|
                format.html
                format.js
            end
        else
            render :js=>'window.location.href="/signin"'
        end
    end

    def delete_whisper
        @id = params[:id]
        Whisper.find(@id).destroy
        respond_to do |format|
            format.html
            format.js
        end
    end

    def settings
        if !signed_in?
            redirect_to signin_path
        else
            user = current_user
            @setting = Setting.find_by_owner(user.id)
        end
    end

    def toggle_history
        directive = params[:directive]
        user = current_user
        setting = Setting.find_by_owner(user.id)
        @flag = -1
        if directive == "0"#close
            setting.history = false
            setting.save
            puts '111111111111111111111'
            @flag = 0
        end

        if directive == "1"#open
            setting.history == true
            setting.save
            @flag = 1
        end

        respond_to do |format|
            format.html
            format.js
        end
    end

    def toggle_whisper
        directive = params[:directive]
        user = current_user
        setting = Setting.find_by_owner(user.id)
        @flag = -1
        if directive == "0"#close
            setting.whisper = false
            setting.save
            @flag = 0
        end

        if directive == "1"#open
            setting.whisper = true
            setting.save
            @flag = 1
        end

        respond_to do |format|
            format.html
            format.js
        end
    end
end