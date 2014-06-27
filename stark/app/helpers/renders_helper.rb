module RendersHelper
   def hasMadeEstimate?(episode_id, user_id)
   	res = Estimate.where(:episode_id=>episode_id, :user_id=>user_id)
   	!(res.to_a.length == 0)
   end
end
