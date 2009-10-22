Factory.define(:user) do |f|
  f.sequence(:login) { |i| "user-#{i}" }
  f.email { |u| "#{u.login}@example.com" }
  f.password "secret"
  f.password_confirmation { |u| u.password }
end