# coding: utf-8

desc "Test weekly"
task "test-weekly", [:date] do |t, args|
  args.with_defaults(:date => "all")
  weekly_date = args[:date]
  weekly_date = find_latest_weekly.split("-weekly.md").at(0) if weekly_date == "latest"

  Dir.foreach(get_weekly_dir) do |weekly_file|
    if weekly_file == "." || weekly_file == ".."
      next
    end

    if weekly_date != "all" && weekly_file != "#{weekly_date}-weekly.md"
      next
    end

    puts "[INFO] Checking #{weekly_file}...".green

    begin
      content = YAML.load(open("#{get_weekly_dir}/#{weekly_file}").read)
    rescue Psych::SyntaxError => e
      show_error("Syntax error found in #{weekly_file}: #{e}")
      exit(1)
    end

    title_record = {}
    comment_record = {}
    link_record = {}

    content["articles"].each_with_index do |article, index|
      article["title"] = "" if !article.has_key?("title")
      article["link"] = "" if !article.has_key?("link")
      article["comment"] = "" if !article.has_key?("comment")
      article_info = {
        :file_name => weekly_file,
        :index => index,
        :title => article["title"],
        :link => article["link"],
        :comment => article["comment"],
      }
      # check empty
      if article["title"].empty?
        show_message_on_article("ERROR", "Empty title of an article", article_info, :title)
        exit 1
      end
      if article["link"].empty?
        puts "[ERROR] Empty link within a weekly found:"
        show_message_on_article("ERROR", "Empty link of an article", article_info, :link)
        exit 1
      end
      if article["comment"].empty?
        show_message_on_article("WARNING", "Empty comment of an article", article_info, :comment)
      end
      # check title duplicate
      if title_record.has_key? article["title"]
        show_message_on_article("ERROR", "Duplicated title within a weekly", article_info, :title)
        exit 1
      end
      title_record[article["title"]] = 1
      # check link duplicate
      if link_record.has_key? article["link"]
        show_message_on_article("ERROR", "Duplicated link within a weekly", article_info, :link)
        exit 1
      end
      link_record[article["link"]] = 1
      # check comment duplicate
      if comment_record.has_key? article["comment"]
        show_message_on_article("ERROR", "Duplicated comment within a weekly", article_info, :comment)
        exit 1
      end
      comment_record[article["comment"]] = 1
    end
  end

  show_success
end
