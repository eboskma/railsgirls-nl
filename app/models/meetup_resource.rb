#
# ActiveResource Models for the meetup.com api.
#
class MeetupResource < ActiveResource::Base

  self.site = "http://api.meetup.com/"

  attr_accessor :api_key

  if RAILS_ENV != 'production'
    ActiveResource::Base.logger = RAILS_DEFAULT_LOGGER
  end
  
  # Get your API key at http://www.meetup.com/meetup_api/key/?op=reset
  APIKEY = "put-your-api-key-here" 

  module MeetupXmlFormat
    extend self

    def extension 
      "xml"
    end

    def mime_type
      "application/xml"
    end

    def decode(xml)
      # ISO-8859-1 works both OS X and Solaris
      Hash.from_xml(xml.sub('latin-1','ISO-8859-1'))["results"]["items"].values
    end

  end

  self.format = MeetupResource::MeetupXmlFormat

  def self.find(scope, args = {})
    if args[:params]
      args[:params].merge!({:key => @api_key || APIKEY })
    end
    super(scope, args)
  end

end