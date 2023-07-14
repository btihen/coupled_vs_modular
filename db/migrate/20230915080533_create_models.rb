# frozen_string_literal: true

class CreateModels < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :street, null: false
      t.string :city, null: false
      t.string :zip, null: false
      t.string :country, null: false
    end

    create_table :passcodes do |t|
      t.string :name, null: false
      t.string :street, null: false
      t.string :zip, null: false
      t.string :city, null: false
      t.string :country, null: false
      t.integer :passcode, null: false
    end

    create_table :people do |t|
      t.string :name, null: false
      t.references :address, null: false, foreign_key: true
    end

    create_table :users do |t|
      t.string :email, null: false
      t.string :password, null: false
      t.boolean :is_admin, null: false, default: false
      t.references :person, foreign_key: true
    end

    create_table :securities do |t|
      t.integer :quantity, null: false
      t.string :ticker, null: false
      t.references :user, null: false, foreign_key: true
    end
  end
end
