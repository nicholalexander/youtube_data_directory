class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.integer :view_count
      t.integer :comment_count
      t.integer :subscriber_count
      t.boolean :hidden_subscriber_count
      t.integer :video_count
      t.string :channel_id
      t.string :channel_etag
      t.string :category_id
    end
  end
end
