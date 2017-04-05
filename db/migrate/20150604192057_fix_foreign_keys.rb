class FixForeignKeys < ActiveRecord::Migration

  def change
    remove_foreign_key :invitations, :teams
    add_foreign_key :invitations, :teams, on_delete: :cascade

    remove_foreign_key :team_groups, :subscriptions
    add_foreign_key :team_groups, :subscriptions, on_delete: :cascade

    remove_foreign_key :checkouts, :users
    add_foreign_key :checkouts, :users, on_delete: :cascade

    remove_foreign_key :checkouts, :plans
    add_foreign_key :checkouts, :plans, on_delete: :cascade
  end

end
