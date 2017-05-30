# == Schema Information
#
# Table name: search_engines
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  active     :boolean          default(TRUE)
#  gcse_id    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe SearchEngine, :type => :model do
  describe "factory" do
    let(:search_engine) { build :search_engine }
    it {
      expect(search_engine).to be_valid
    }
  end
end
