class EpisodesController < ApplicationController
    def show
      @episode = Episode.find(params[:id])
    end
 
    def new
      if !signed_in?
        redirect_to signin_path
      end
      @episode = Episode.new
    end

    def create
      name = current_user.name
      script = episode_params[:script]
      image_io = episode_params[:image]
      if image_io != nil
        image_name = Time.new.to_s.split.join("-") + "-" + image_io.original_filename
        image_name = Digest::SHA1.hexdigest image_name
        image_url = Rails.root.join('public', 'images', image_name)
        File.open(image_url, 'wb') do |file|
           file.write(image_io.read)
        end
        new_params = {:name=>name, :script=>script, :image_url=>image_name, :good_num=>0, :bad_num=>0, :comment_num=>0}
        @episode = Episode.new(new_params)
      else
        new_params = {:name=>name, :script=>script, :image_url=>nil, :good_num=>0, :bad_num=>0, :comment_num=>0}
        @episode = Episode.new(new_params)
      end
      if @episode.save
        redirect_to root_path
      else
         render "new"
      end
    end
   
    private   
      def episode_params
        params.require(:episode).permit(:name, :script, :image)
      end
end
