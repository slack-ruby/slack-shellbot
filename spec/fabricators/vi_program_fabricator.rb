Fabricator(:vi_program, class_name: 'ViProgram', from: :program) do
  file_entry { Fabricate(:file_entry) }
  filename { Faker::Lorem.word + '.txt' }
end
