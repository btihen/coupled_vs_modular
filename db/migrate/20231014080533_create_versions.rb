# frozen_string_literal: true

class CreateVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :address_versions do |t|
      t.references :address, null: false, foreign_key: true
      t.string :street
      t.string :city
      t.string :zip
      t.string :country
      t.date :valid_from, null: false

      t.timestamps
    end

    create_table :name_versions do |t|
      t.references :person, null: false, foreign_key: true
      t.string :name
      t.date :valid_from, null: false

      t.timestamps
    end

    remove_column :people, :name, :string

    remove_column :addresses, :street, :string
    remove_column :addresses, :city, :string
    remove_column :addresses, :zip, :string
    remove_column :addresses, :country, :string
  end
end
