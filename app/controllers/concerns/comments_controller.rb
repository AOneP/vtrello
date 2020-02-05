class CommentsController < ApplicationController

  def new
  end

  def create
    todopoint_comment = todopoint.comments.new(comment_params)
    if todopoint_comment.save
      redirect_to list_todopoint_path(todopoint.list, todopoint), notice: I18n.t('comments.notifications.create')
    else
      redirect_to list_todopoint_path(todopoint.list, todopoint), notice: I18n.t('common.notifications.wrong')
    end
  end

  def edit
    comment
  end

  def update
    if comment.update(comment_params)
      redirect_to list_todopoint_path(todopoint.list, todopoint), notice: I18n.t('comments.notifications.update')
    else
      render :edit
    end
  end

  def destroy
    if comment.destroy
      redirect_to list_todopoint_path(todopoint.list, todopoint), notice: I18n.t('comments.notifications.destroy')
    else
      redirect_to list_todopoint_path(todopoint.list, todopoint), notice: I18n.t('common.notifications.wrong')
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :author)
  end

  def todopoint
    @todopoint ||= Todopoint.find(params[:todopoint_id])
  end

  def comment
    @comment ||= todopoint.comments.find(params[:id])
  end

end
