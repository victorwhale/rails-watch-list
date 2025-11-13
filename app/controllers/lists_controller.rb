class ListsController < ApplicationController
  before_action :set_list, only: :show

  def index
    @lists = List.all
  end

  def show
    @bookmark = Bookmark.new
    @movies = Movie.all
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    if @list.save
      redirect_to list_path(@list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def list_params
    params.require(:list).permit(:name, :image_url)
  end

  def set_list
    @list = List.find_by!(slug: params[:slug])
  end
end
