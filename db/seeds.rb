require_relative 'seeds/helpers'
require_relative 'seeds/users'

ActiveRecord::Base.transaction do
  log 'Starting seeds'

  begin
    create_users
    # create other seeds here

    log 'Seeding completed successfully'
  rescue StandardError => e
    log "Seeding failed: #{e.message}"
    raise ActiveRecord::Rollback
  end
end
