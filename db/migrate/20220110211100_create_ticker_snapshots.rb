class CreateTickerSnapshots < ActiveRecord::Migration[7.0]
  def change
    create_table :ticker_snapshots do |t|
      t.string :symbol
      t.integer :volume
      t.float :volatility
      t.float :short_float
      t.float :short_ratio
      t.integer :shares_float
      t.float :rsi
      t.json :full_payload

      t.timestamps
    end
  end
end
