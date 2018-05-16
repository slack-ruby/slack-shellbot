Fabricator(:directory_entry) do
  name { Faker::Lorem.word }
  file_system { (FileSystem.first || Fabricate(:file_system)) }
  before_create do |obj|
    obj.parent_directory_entry ||= obj.file_system.root_directory_entry
  end
end
