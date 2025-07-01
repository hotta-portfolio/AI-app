class HomeController < ApplicationController
  def index
    @knowhows = @q.result(distinct: true).includes(:user, media_files_attachments: :blob).order(created_at: :desc)
  end
end
