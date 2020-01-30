class CommentsController < ApplicationController

  def new
    @comment = Comment.new
  end

  def create
    comment = Comment.new(comment_params)
    if comment.save
      redirect_to todopoints_path, notice: 'Dzięki za komentarz! :)'
    else
      redirect_to todopoint_path, alert: 'Coś poszło źle!'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    comment = Comment.find(params[:id])
    if comment.update(comment_params)
      redirect_to todopoints_path, notice: 'Aktualizowałeś komentarz!'
    else
      redirect_to todopoints_path, alert: 'Coś poszło źle'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
