# coding: utf-8

require "colorize"
require "date"
require "octokit"
require "yaml"
require "os"
require "spacifier"
require "terminal-table"

Dir.glob('rake/**.rake').each do |f|
  import f
end

def show_success
  show_info("Success.")
end

def show_info(message)
  puts "[INFO] #{message}".green
end

def show_error(message)
  puts "[ERROR] #{message}".red
end

def show_message_on_article(level, message, article, highlight_item)
  puts "[#{level}] #{message.capitalize}:"

  article.each do |key, item|
    line = case key
    when :file_name
      "  Filename: #{article[:file_name]}"
    when :index
      "      Item: #{article[:index]}"
    when :title
      "     Title: #{article[:title]}"
    when :link
      "      Link: #{article[:link]}"
    when :referrer
      "  Referrer: #{article[:referrer]}"
    when :comment
      "   Comment: #{article[:comment]}"
    when :tags
      "      Tags: #{article[:tags]}"
    end

    if key == highlight_item
      case level
      when "ERROR"
        line = line.red
      when "WARNING"
        line = line.yellow
      end
    end

    puts line
  end
end

def find_latest_weekly
  Dir.entries(get_weekly_dir).reject do |entry|
    entry == "." || entry == ".."
  end.sort_by do |x|
    Date.strptime(x.split("-weekly.md").at(0), "%Y-%m-%d").to_time.to_i
  end.last
end

def get_access_token
  access_token = ENV["ACCESS_TOKEN"]

  if access_token == nil || access_token.empty?
    puts "[ERROR] No ACCESS_TOKEN is set.".red
    return false
  end

  access_token
end

def get_weekly_repo
  "crispgm/weekly".freeze
end

def get_weekly_dir
  "_posts".freeze
end

def get_newsletter_dir
  "_newsletter".freeze
end
