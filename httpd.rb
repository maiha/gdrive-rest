require 'sinatra'
load File.join(__dir__, 'gdrive.rb') # extend GoogleDrive

configure do
  set :bind, (ENV['GDRIVE_BIND'] || "localhost").to_s
  set :port, (ENV['GDRIVE_PORT'] || 8080).to_i
  set :dump_errors, (!! ENV['GDRIVE_DUMP_ERRORS'])
end

error Gdrive::NotFound do
  status 404
  body env['sinatra.error'].message
end

get '/' do
  "GDRIVE_CONFIG: #{ENV['GDRIVE_CONFIG']}"
end

# GET /sheets/:key.csv
get %r{/sheets/([A-Za-z0-9_-]+)(\.([a-z]+))?} do |key, _, ext|
  sheets = Gdrive.spread(key).sheets
  case ext.to_s
  when "html"
    lis = sheets.map(&:attrs).map{|h|
      "<li><a href='#{h['path']}.html'>#{h['title']}</a></li>"
    }.join
    body "<ul>#{lis}</ul>"
  when "json"
    content_type :json
    body sheets.map(&:attrs).to_json
  when "txt", ""
    content_type :text
    body sheets.map(&:to_s).join("\n")
  else
    status 415
    body "Unsupported Media Type: '#{ext}'"
  end
end

# GET /sheets/aaaa/0.csv
get %r{/sheets/([A-Za-z0-9_-]+)/([^\.\?/]+)(\.([a-z]+))?} do |key, pos, _, ext|
  rows = ->{ Gdrive.spread(key).sheet(URI.unescape(pos)).rows }
  case ext
  when "html"
    body "<pre>%s</pre>" % rows.call.inspect
  when "json"
    content_type :json
    body rows.call.to_json
  when "csv"
    content_type :text
    body rows.call.map{|cols| cols.to_csv.chomp}.join("\n")
  when "tsv"
    content_type :text
    body rows.call.map{|cols| cols.map(&:to_s).join("\t")}.join("\n")
  when "txt", ""
    content_type :text
    body rows.call.map{|cols| cols.map(&:to_s).join(" ")}.join("\n")
  else
    status 415
    body "Unsupported Media Type: '#{ext}'"
  end
end

# First, build a new session to ensure the credential file is valid.
Gdrive.new_session
