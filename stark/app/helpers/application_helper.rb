module ApplicationHelper
    def intel_title(page_title)
        base_title = "Stark"
        if page_title.empty?
            base_title
        else
            "#{base_title} | #{page_title}"
        end  
    end
end
