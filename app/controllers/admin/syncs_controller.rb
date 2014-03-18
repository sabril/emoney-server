class Admin::SyncsController < InheritedResources::Base
  before_filter :authenticate_user!
  
  protected
  def collection
    @syncs ||= end_of_association_chain.order(sort_column + " " + sort_direction).page(params[:page]).per(20)
  end
end