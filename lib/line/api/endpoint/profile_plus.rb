module Line
  module Api
    module Endpoint
      module ProfilePlus

        def issue_profile_plus_import_path(user_access_token)
          conn = build_connection
          conn.authorization :Bearer, user_access_token
          res = conn.get { |req| req.url('profileplus/issue/import') }
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          res.body #  {"url":"http://profileplus.line.me/passport/import?token=xxx"}
        end

        def issue_profile_plus_export_path(user_access_token)
          conn = build_connection
          conn.authorization :Bearer, user_access_token
          res = conn.get { |req| req.url('profileplus/issue/export') }
          raise Error::Communication, "Invalid HTTP Status: #{res.status}. #{res.body}" if res.status != 200
          res.body #  {"url":"http://profileplus.line.me/passport/import?token=xxx"}
        end

      end
    end
  end
end
