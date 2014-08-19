module ApplicationHelper

	def title(title)
		content_for(:title) { "#{title} | "}
		content_tag(:h2, title, class: "page-title truncate", title: title)
	end

end
