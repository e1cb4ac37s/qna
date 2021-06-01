module DestroyLinks
  def destroy_links(params, linkable)
    links_params = params.require(:links_attributes)
    should_reload = false
    links_params.each do |lp|
      if lp[1][:_destroy] != 'false'
        Link.destroy(lp[1][:id])
        should_reload = true
      end
    end
    linkable.reload if should_reload
  end
end