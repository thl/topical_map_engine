class SakaiSessionApi < ActionWebService::API::Base
  api_method :testsign, :expects => [:string], :returns => [:string]
end