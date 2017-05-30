unless User.exists?(role: "admin")
  # create admin if there's no admin
  email = "admin@example.com"
  password = "12345678"
  User.create!(name: "admin", email: email, password: password, role: "admin")
  puts "Se ha creado el administrador #{email} con contraseña #{password}"
end

if SearchEngine.count == 0
  puts "creating search engines.."
  [
   {name: "Google",
    slug: "google",
    gcse_id: "018227999646376107175:onnoxl8c1a0"},
   {name: "Wikipedia",
    slug: "wikipedia",
    gcse_id: "018227999646376107175:npe9hpc24qi"},
   {name: "Encyclopedia",
    slug: "encyclopedia",
    gcse_id: "018227999646376107175:gy3ybc1pe88"},
   {name: "Info Please",
    slug: "infoplease",
    gcse_id: "018227999646376107175:sgcwslpgclu"},
   {name: "Britanica",
    slug: "britanica",
    gcse_id: "018227999646376107175:ngvuyee7y8u"},
   {name: "Kids",
    slug: "academickids",
    gcse_id: "018227999646376107175:f7lgjvvd15y"},
   {name: "Reference",
    slug: "reference",
    gcse_id: "018227999646376107175:cwx1zp7aaym"},
   {name: "Vikidia",
    slug: "vikidia",
    gcse_id: "011997207316538633130:jtyj-gczrmc"}
  ].each do |attrs|
    SearchEngine.create! attrs
  end
end
