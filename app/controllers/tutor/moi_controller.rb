module Tutor
  class MoiController < TutorController::Base

    def index
      if params[:search]
        @clients =  UserClientSearch.new(q:params[:search]).results
      else
        @clients = User.where(:role => :cliente)
      end
    end
  end
end
