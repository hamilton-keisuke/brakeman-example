class GenerateListForXxxJob < ApplicationJob
  LIMIT = 10000

  SQL = <<~EOS.freeze
    SELECT
      posts.title
      posts.comment
    FROM
      posts
    ORDER BY
      posts.created_at DESC
    LIMIT
      #{LIMIT}
  EOS

  TMP_FILE = "tmp/post_list_for_xxx.csv".freeze

  def perform(*args)
    host = ENV["DB_HOST"]
    username = db_config["DB_USERNAME"]
    password = db_config["DB_PASSWORD"]
    database = db_config["DB_DATABASE"]
    system("mysql -h#{host} -u#{username} -p#{password} -D#{database} -N -e\"#{SQL}\" | sed 's/\t/,/g' > #{TMP_FILE}", exception: true)
  end
end
