class AddLogoUrlToLeagues < ActiveRecord::Migration[5.1]
  def change
    add_column :leagues, :logo_url, :string
  end
end
