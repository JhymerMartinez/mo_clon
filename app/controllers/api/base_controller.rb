module Api
  class BaseController < ::ApplicationController
    include NeuronScope
    include JsonRequestsForgeryBypass
    include DeviseTokenAuth::Concerns::SetUserByToken
  end
end
