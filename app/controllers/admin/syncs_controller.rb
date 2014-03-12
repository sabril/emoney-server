class Admin::SyncsController < InheritedResources::Base
  before_filter :authenticate_user!
end