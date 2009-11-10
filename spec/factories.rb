Factory.define(:user) do |f|
  f.sequence(:login) { |i| "user-#{i}" }
  f.email { |u| "#{u.login}@example.com" }
  f.password "secret"
  f.password_confirmation { |u| u.password }
end

Factory.define(:question) do |f|
  f.sequence(:body) {|i| "bet #{i} dollars on blackjack"}
  f.association(:user)
end

Factory.define(:answer) do |f|
  f.sequence(:body) {|i| "answer #{i}"}
  f.sequence(:choice) { (rand() * 3).to_i + 1 }
  f.association(:question)
  f.association(:user)
end

Factory.define(:event) do |f|
end

Factory.define(:question_event, :parent => :event) do |f|
  f.association(:target, :factory => :question)
end

Factory.define(:answer_event, :parent => :event) do |f|
  f.association(:target, :factory => :answer)
end
