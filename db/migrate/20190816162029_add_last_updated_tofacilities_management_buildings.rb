class AddLastUpdatedTofacilitiesManagementBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_buildings, :status, :string, null: false, default: 'Incomplete'
    change_column_default :facilities_management_buildings, :updated_at, from: nil, to: 'now()'
  end
end
