# require "neo_importer"
#
# namespace :data do
#   desc "Import data from legacy neo4j database. `rake data:import_from_neo NEOUSER=neo4j NEOPASSWD=secret`"
#   task import_from_neo: :environment do
#     NeoImporter.new.run!
#   end
#
#   desc "Fix legacy media. `rake data:fix_legacy_media HOST=http://moi.shiriculapo.com`"
#   task fix_legacy_media: :environment do
#     NeoImporter::FixLegacyMedia.new.run!
#   end
# end
