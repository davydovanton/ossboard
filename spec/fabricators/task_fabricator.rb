Fabricator(:task) do
  title           { Faker::Lorem.word }
  repository_name { Faker::Lorem.word }
  body            { Faker::Lorem.paragraph }
  link            { Faker::Internet.url }
  md_body         { Faker::Lorem.paragraph }
  issue_url       { Faker::Internet.url('github.com', "/davydovanton/ossboard/issues/#{Faker::Number.number(2)}") }
  approved        false
  lang            'ruby'
  complexity      'easy'
  status          'in progress'
  first_pr        true
end
