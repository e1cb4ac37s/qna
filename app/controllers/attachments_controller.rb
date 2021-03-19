class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @record = @file.record
    @file.purge if current_user.author_of?(@record)
  end
end