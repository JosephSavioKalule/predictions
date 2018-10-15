class CreateSettingsBoxes < ActiveRecord::Migration[5.1]
  def change
    create_table :settings_boxes do |t|
      t.boolean :receive_email, default: false

      t.timestamps
    end
  end
end
