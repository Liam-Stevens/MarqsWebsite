class CommentsController < ApplicationController
  def create
    @submission = Submission.find(params[:submission_id])
    @comment = @submission.comments.create!(params[:comments])
    redirect_to submissions_path
  end

  def new
    @submission = Submission.find(params[:submission_id])
    @comment = @submission.comment.new
  end
end
