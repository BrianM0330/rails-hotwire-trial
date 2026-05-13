require "csv"

def required_photo_seed_value(row, header)
  value = row[header]
  raise KeyError, "missing required CSV field: #{header}" if value.blank?

  value
end

def required_photo_seed_integer(row, header)
  Integer(required_photo_seed_value(row, header))
end

photo_csv_path = Rails.root.join("photos.csv")
photo_seed_errors = []
photo_seed_count = 0

if photo_csv_path.exist?
  begin
    CSV.foreach(photo_csv_path, headers: true).with_index(2) do |row, line_number|
      begin
        now = Time.current

        Photo.upsert(
          {
            pexels_id: required_photo_seed_integer(row, "id"),
            width: required_photo_seed_integer(row, "width"),
            height: required_photo_seed_integer(row, "height"),
            url: required_photo_seed_value(row, "url"),
            photographer: required_photo_seed_value(row, "photographer"),
            photographer_url: required_photo_seed_value(row, "photographer_url"),
            photographer_id: required_photo_seed_integer(row, "photographer_id"),
            avg_color: required_photo_seed_value(row, "avg_color"),
            alt: required_photo_seed_value(row, "alt"),
            created_at: now,
            updated_at: now
          },
          unique_by: :pexels_id
        )

        photo_seed_count += 1
      rescue ArgumentError, KeyError, ActiveRecord::ActiveRecordError, TypeError => error
        photo_seed_errors << {
          line_number:,
          error: error.message,
          row: row.to_h
        }
      end
    end

    puts "Seeded #{photo_seed_count} photos from #{photo_csv_path.basename}."
  rescue CSV::MalformedCSVError => error
    photo_seed_errors << {
      line_number: error.line_number,
      error: error.message,
      row: nil
    }
  end
else
  photo_seed_errors << {
    line_number: nil,
    error: "CSV file not found: #{photo_csv_path}",
    row: nil
  }
end

%w[
  brian@clever.com
  ryan@clever.com
  jake@clever.com
  mike@clever.com
  admin@clever.com
].each do |email_address|
  user = User.find_or_initialize_by(email_address:) # no upsert here because password digest flow
  user.password = "password"
  user.save!
end

puts "Seeded Clever users."

seed_users = User.where(email_address: %w[
  brian@clever.com
  ryan@clever.com
  jake@clever.com
  mike@clever.com
  admin@clever.com
]).order(:email_address).to_a
seed_photos = Photo.order(:pexels_id).to_a

if seed_users.any? && seed_photos.any?
  seeded_likes_count = 0
  seeded_comments_count = 0

  seed_photos.each_with_index do |photo, photo_index|
    liker_count = (photo_index % seed_users.size) + 1

    seed_users.first(liker_count).each do |user|
      like = user.likes.create_or_find_by!(photo:)
      seeded_likes_count += 1 if like.previously_new_record?
    end
  end

  comment_bodies = [
    "The color palette on this one is excellent.",
    "This would look great as a hero image.",
    "Love the composition here.",
    "The lighting makes this feel really calm.",
    "Strong candidate for the gallery grid.",
    "The crop options should work well for this photo.",
    "This one has a nice sense of depth."
  ]

  seed_photos.each_with_index do |photo, photo_index|
    comment_count = photo_index % 4

    comment_count.times do |comment_index|
      user = seed_users[(photo_index + comment_index) % seed_users.size]
      body = comment_bodies[(photo_index + comment_index) % comment_bodies.size]
      comment = Comment.find_or_create_by!(user:, photo:, body:)
      seeded_comments_count += 1 if comment.previously_new_record?
    end
  end

  puts "Seeded #{seeded_likes_count} new likes and #{seeded_comments_count} new comments."
else
  warn "======== WARNING: Skipped social seeds because photos or users are missing. ========"
end

if photo_seed_errors.any?
  warn "======== WARNING: Photo seed skipped #{photo_seed_errors.size} row(s): ========"

  photo_seed_errors.each do |seed_error|
    warn "Line #{seed_error[:line_number] || "n/a"}: #{seed_error[:error]}"
    warn seed_error[:row].inspect if seed_error[:row]
  end
end
