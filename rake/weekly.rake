# coding: utf-8

namespace :weekly do
  desc "Create weekly with scaffold"
  task :create, [:date] do |t, args|
    args.with_defaults(:date => Time.now.strftime("%Y-%m-%d"))
    weekly_date = args[:date]
    weekly_content = <<-EOF
---
articles:
  - title:    "Your Awesome Article Title"
    link:     "https://crispgm.github.io/weekly/"
    comment:  "The reason why you recommend this article."
---
    EOF

    create_weekly(weekly_date, weekly_content)
  end

  desc "Open weekly issue"
  task :open, [:date] do |t, args|
    args.with_defaults(:date => Time.now.strftime("%Y-%m-%d"))
    weekly_date = args[:date]

    open_issue(weekly_date)
  end

  desc "Publish weekly"
  task :publish, [:date] do |t, args|
    args.with_defaults(:date => "latest")
    weekly_date = args[:date]
    weekly_date = find_latest_weekly.split("-weekly.md").at(0) if weekly_date == "latest"
    show_info("Publishing")
    # commit
    msg = "Weekly #{weekly_date} published"
    sh "git add ."
    sh "git commit --allow-empty -m \"#{msg}\""
    sh "git push"
    # close issue
    close_issue(weekly_date)
  end

  desc "Import weekly articles"
  task :import, [:date] do |t, args|
    args.with_defaults(:date => Time.now.strftime("%Y-%m-%d"))
    weekly_date = args[:date]
    # do import from github issues
    articles = import_articles_from_issues(get_issue_name(weekly_date))
    if articles == false
      puts "[ERROR] Import articles error!".red
      exit 1
    end
    # build frontmatter
    weekly_content = "---\narticles:\n"
    articles.each do |item|
      weekly_content << "  - title:    \"#{item[:title]}\"\n"
      weekly_content << "    link:     \"#{item[:link]}\"\n"
      weekly_content << "    comment:  \"#{item[:comment]}\"\n" unless item[:comment].empty?
    end
    weekly_content << "---\n"

    create_weekly(weekly_date, weekly_content)
  end

  desc "Edit the latest weekly"
  task "edit-latest" do
    latest = find_latest_weekly
    sh "$EDITOR #{get_weekly_dir}/#{latest}"
  end

  desc "Open the latest issue"
  task "open-latest-issue" do
    link = find_issue_link
    if OS.mac?
      sh "open #{link}"
    else
      puts link
      raise StandardError, "Cannot open in non-mac system"
    end
  end
end

def get_issue_name(weekly_date)
  "#{weekly_date}"
end

def create_weekly(weekly_date, weekly_content)
  html_file = "#{get_weekly_dir}/#{weekly_date}-weekly.md"
  File.new(html_file, "w").syswrite(weekly_content)

  show_info("#{html_file} is created.")
end

def import_articles_from_issues(issue_name)
  return false if issue_name.empty?
  client = Octokit::Client.new(:access_token => get_access_token)
  # find issue
  issues = client.list_issues(get_weekly_repo, options = {:state => "open"})
  number = 0
  issues.each do |issue|
    if issue[:title].eql? issue_name
      number = issue[:number]
      break
    end
  end
  # fetch issue comment
  issue_comment = client.issue_comments(get_weekly_repo, number)
  # iterate issue comment to import articles
  articles = Array.new
  issue_comment.each do |item|
    body = item[:body]
    title = ""
    link = ""
    comment = ""

    lines = body.split("\r\n")
    if lines.length == 1
      lines = body.split("\n")
    end
    lines.each_with_index do |line, i|
      if line.strip.empty?
        next
      end

      case i
      when 0
        if !line.strip.eql?("/post")
          puts "[INFO] Skip comment #{number}:#{item[:id]}".yellow
          break
        end
      when 1
        title = Spacifier.spacify(line.strip.split("- ").at(1))
        title.gsub!("\"", "\\\"")
      when 2
        link = line.strip.split("- ").at(1)
      when 3
        comment = Spacifier.spacify(line.strip.split("- ").at(1))
        comment.gsub!("\"", "\\\"")
      end
    end
    articles << { :title => title, :link => link, :comment => comment }
  end

  show_info("Import #{articles.count} article(s).")
  articles
end

def close_issue(weekly_date)
  client = Octokit::Client.new(:access_token => get_access_token)
  # find issue
  issues = client.list_issues(get_weekly_repo, options = {:state => "open"})
  number = 0
  issues.each do |issue|
    if issue[:title].eql? get_issue_name(weekly_date)
      number = issue[:number]
      break
    end
  end
  url = weekly_url(weekly_date)
  comment = <<-EOS
:fireworks:Congratulations!
:scroll:Crisp Weekly #{weekly_date} is published on <#{url}>.
  EOS

  client.add_comment(get_weekly_repo, number, comment)
  show_info("Publishing on issue...")
  # close issue
  client.close_issue(get_weekly_repo, number)
  show_info("Closing issue...")

  show_success
end

def open_issue(weekly_date)
  client = Octokit::Client.new(:access_token => get_access_token)
  content = <<-EOS
:loud_sound:Crisp Weekly #{weekly_date} is now in collecting.
  EOS
  client.create_issue(get_weekly_repo, get_issue_name(weekly_date), content)

  show_success
end

def find_issue_link
  client = Octokit::Client.new(:access_token => get_access_token)
  # find issue
  issues = client.list_issues(get_weekly_repo, options = {:state => "open"})
  number = 0
  issues.each do |issue|
    number = issue[:number]
    break
  end
  "https://github.com/#{get_weekly_repo}/issues/#{number}"
end

def weekly_url(weekly_date)
  weekly_url_date = weekly_date.split("-").join("/")
  "https://crispgm.github.io/weekly/#{weekly_url_date}/weekly.html"
end
