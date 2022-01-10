class CreateTickerSnapshots < ActiveRecord::Migration[7.0]
  def change
    create_table :ticker_snapshots do |t|
      t.string :symbol
      t.integer :volume
      t.string :volatility
      t.float :short_float
      t.float :short_ratio
      t.string :shares_float
      t.string :float
      t.float :rsi
      t.json :full_payload

      t.timestamps
    end
  end
end
