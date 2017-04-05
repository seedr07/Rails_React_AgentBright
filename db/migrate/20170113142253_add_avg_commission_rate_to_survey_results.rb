class AddAvgCommissionRateToSurveyResults < ActiveRecord::Migration[5.0]
  def change
    add_column :survey_results, :avg_commission_rate, :decimal
  end
end
