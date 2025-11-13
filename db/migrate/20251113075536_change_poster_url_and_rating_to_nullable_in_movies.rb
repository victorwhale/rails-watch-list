class ChangePosterUrlAndRatingToNullableInMovies < ActiveRecord::Migration[7.1]
  def change
    change_column_null :movies, :poster_url, true
    change_column_null :movies, :rating, true
  end
end
