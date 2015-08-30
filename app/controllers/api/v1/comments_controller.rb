class Api::V1::CommentsController < MasterApiController
	respond_to :json

	def index
		render json: Comment.all
	end

	def show
		render json: comment
	end

	def create
		render json: Comment.create(comment_params)
	end

	def update
		render json: comment.update(comment_params)
	end

	def destroy
		render json: comment.destroy
	end

	private

	def comment
		Comment.find(params[:id])
	end

	def comment_params
		params.require(:comment).permit(:text, :user_id, :post_id, :empathy_level, :soft_delete_date, :soft_delete, :hidden)
	end
end
