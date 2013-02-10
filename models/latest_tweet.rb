require 'uri'

class LatestTweet
  def self.find
    last_seen_id = -1
    conn = connect()
    begin
      conn.exec("SELECT last_tweet FROM tweets") do |result|
        result.each do |row|
          last_seen_id = row.values_at('last_tweet').first
        end
      end
    ensure
      conn.close
    end

    last_seen_id
  end


  def self.update(latest_id)
    conn = connect()
    begin
      conn.exec("UPDATE tweets set last_tweet = '#{latest_id}'")
    ensure
      conn.close
    end
  end


  private
  def self.connect
    db = URI.parse(ENV["DATABASE_URL"] || "postgres://localhost/linuxdb")

    if db.user
      db_conn = { host: db.host, dbname: db.path[1..-1], port: db.port, user: db.user, password: db.password }
    else
      db_conn = { dbname: db.path[1..-1] }
    end

    PG.connect(db_conn)
  end

end
