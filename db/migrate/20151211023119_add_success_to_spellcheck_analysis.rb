class AddSuccessToSpellcheckAnalysis < ActiveRecord::Migration
  def change
    add_column :spellcheck_analyses, :success, :boolean, default: false
  end
end
