# As suggested on http://stackoverflow.com/questions/27773368/rails-4-2-internal-server-error-with-maximum-file-multiparts-in-content-reached#answer-27784531

Rack::Utils.multipart_part_limit = 0
