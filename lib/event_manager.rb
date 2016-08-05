require 'csv'
require 'sunlight/congress'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"
template_letter = File.read 'form_letter.html'

#if the zip is exactly 5 digits it is ok
#if the zip is less than 5 digits pad it with zeroes
#if the zip is more than 5 digits truncate it to the first 5
def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zipcode)
	legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
	legislator_names = legislators.collect do |legislator|
		"#{legislator.first_name} #{legislator.last_name}"
	end
	legislator_names.join(', ')
end

puts 'EventManager Initialized!'
contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol
contents.each do |row|
	name = row[:first_name]
	zipcode = clean_zipcode(row[:zipcode])
	legislators = legislators_by_zipcode(zipcode)

	personal_letter = template_letter.gsub('FIRST_NAME', name)
	personal_letter.gsub!('LEGISLATORS', legislators)

	
	puts personal_letter
end