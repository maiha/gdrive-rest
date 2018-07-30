require "google_drive"
require 'csv'

module Gdrive
  class NotFound < RuntimeError; end

  class Spread
    attr_reader :key

    def initialize(ds, key)
      @ds  = ds
      @key = key
      @raw = ds.spreadsheet_by_key(key)
    end

    def raw
      @raw or raise NotFound.new("spreadsheet not found: '#{@key}'")
    end

    def sheet(name)
      case name.to_s
      when /\A\d+\Z/
        Sheet.new(self, name.to_i, nil)
      else
        Sheet.new(self, nil, name.to_s)
      end
    end

    def sheets
      raw.worksheets.map.with_index{|ws, i| Sheet.new(self, i, ws.title, ws)}
    end
  end

  class Sheet
    def initialize(spread, index, title, raw = nil)
      @spread = spread
      @index  = index
      @title  = title
      @raw    = raw
    end

    def sp
      @spread.raw
    end

    def raw
      @raw ||= sp.worksheet_by_title(@title) if @title
      @raw ||= sp.worksheets[@index] if @index
      @raw or raise NotFound.new("worksheet not found: '#{@title || @index}'")
    end

    def title
      @title ||= raw.title
    end

    def attrs
      {
        "index" => @index,
        "title" => @title,
        "path"  => path,
      }
    end

    def to_s
      "#{@index}: #{@title} (#{path})"
    end
    
    def path
      if @title
        "/sheets/%s/%s" % [@spread.key, URI.escape(@title)]
      elsif @index
        "/sheets/%s/%s" % [@spread.key, @index]
      else
        nil
      end
    end
    
    def rows
      raw.rows
    end
  end

  def self.config_path!
    ::File.realpath(ENV['GDRIVE_CONFIG'] || "config.json")
  end

  def self.new_session
    GoogleDrive::Session.from_config(config_path!)
  end

  def self.spread(key)
    Spread.new(new_session, key)
  end
end

if $0 == __FILE__
  Gdrive.new_session.root_collection
  puts "Authorized (#{Gdrive.config_path!})"
end
