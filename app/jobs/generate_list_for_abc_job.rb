class GenerateListForAbcJob < ApplicationJob
  LIMIT = 500

  SQL = <<~EOS.freeze
    SELECT
      posts.title
      posts.comment
    FROM
      posts
    ORDER BY
      posts.created_at ASC
    LIMIT
      #{LIMIT}
  EOS

  TMP_FILE = "tmp/post_list_for_abc.csv".freeze

  def perform(*args)
    posts = Post.all

    CSV.open(TMP_FILE, "wb") do |csv|
      csv << [
        "title",
        "created_at",
        "updated_at"
      ]
      posts.each do |post|
        csv << [
          design["title"],
          design["created_at"],
          design["updated_at"]
        ]
      end
    end
  end
end
