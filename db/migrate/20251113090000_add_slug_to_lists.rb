class AddSlugToLists < ActiveRecord::Migration[7.1]
  class List < ApplicationRecord
    self.table_name = "lists"
  end

  def up
    add_column :lists, :slug, :string
    add_index :lists, :slug, unique: true

    List.reset_column_information
    List.find_each do |list|
      list.update_columns(slug: unique_slug_for(list.name, list.id))
    end

    change_column_null :lists, :slug, false
  end

  def down
    remove_index :lists, :slug
    remove_column :lists, :slug
  end

  private

  def unique_slug_for(name, current_id)
    base_slug = name.to_s.parameterize(separator: '_')
    slug = base_slug
    counter = 2

    while List.where(slug: slug).where.not(id: current_id).exists?
      slug = "#{base_slug}_#{counter}"
      counter += 1
    end

    slug
  end
end
