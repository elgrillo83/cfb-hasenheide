class AddClubTeamIdAndRivalTeamIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :club_team_id, :integer
    add_column :events, :rival_team_id, :integer
  end
end
