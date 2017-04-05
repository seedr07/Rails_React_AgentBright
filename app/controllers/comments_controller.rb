class CommentsController < ApplicationController

  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :load_commentable, except: [:activity_stream_quick_comment]

  def index
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def edit
    @commentable = @comment.commentable
    session[:referring_page] = request.referer || comments_path
    render
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable, notice: "Comment created." }
        format.js do
          # We only need following objects for JS requests.
          case @comment.commentable_type
          when "Lead"
            @lead = @comment.commentable
            @lead_recent_activities = @lead.recent_activities
            @activities_link_url = recent_activities_path(activities_owner_id: @lead.id,
                                                          activities_owner_type: "Lead",
                                                          activity_feed_page: @lead_recent_activities.next_page)
          when "Contact"
            @contact = @comment.commentable
            @contact_recent_activities = @contact.recent_activities
            @activities_link_url = recent_activities_path(activities_owner_id: @contact.id,
                                                          activities_owner_type: "Contact",
                                                          activity_feed_page: @contact_recent_activities.next_page)
          end
        end
      else
        format.html {
          flash.now[:danger] = "Please check your entry and try again."
          render :new
        }
      end
    end
  end

  def update
    @commentable = @comment.commentable
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @commentable, notice: "Comment updated." }
        format.json { head :no_content }
        format.js
      else
        format.html { flash.now[:danger] = "Please check your entry and try again."
                      render :edit
                    }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def activity_stream_quick_comment
    lead = Lead.find(params[:lead_id])
    comment = lead.comments.new
    comment.user = current_user
    comment.content = params[:content]
    if comment.save
      message = "success"
      respond_to do |format|
        format.json { render json: message }
      end
    else
      message = "fail"
      respond_to do |format|
        format.json { render json: message }
      end
    end
  end

  def destroy
    @commentable = @comment.commentable
    session[:referring_page] = request.referer || @commentable
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to session[:referring_page] || @commentable  }
      format.js
      format.json { head :no_content }
    end
  end

  def open_comment_modal
    @comment = @commentable.comments.new
    session[:referring_page] = request.referer || comments_path
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :created_at, :user_id)
  end

  def load_commentable
    if (params[:commentable_type] == "Lead")
      @commentable = Lead.find(params[:commentable_id])
    elsif (params[:commentable_type] == "Contact")
      @commentable = Contact.find(params[:commentable_id])
    else
      resource, id = request.path.split("/")[1, 2]
      @commentable = resource.singularize.classify.constantize.find(id)
    end
    # Alternate method for custom URLs:
    # klass = [Contact, Client].detect { |c| params["#{c.name.underscore}_id"] }
    # @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

end
