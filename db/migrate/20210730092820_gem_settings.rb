
class GemSettings < SpreeExtension::Migration[4.2]
    def change
      create_table :yotpo_settings do |t|
        t.string :yotpo_app_key
        t.string :yotpo_secret
        t.string :yotpo_store_id
      end
    end
  end
  