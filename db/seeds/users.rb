def create_users
  log 'Creating users'
  if User.count.positive?
    log 'Users already exist'
  else
    10.times { FactoryBot.create(:user) }
    log 'Users created'
  end
end
