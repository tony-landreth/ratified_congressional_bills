# TODO: Try collecting the links from each page (starting at pg 7) and write them to file
# TODO: Then visit each link and try scraping txt
# FORMAT changes around 5,076. H.R.5252, which is pg 21

require 'watir'
require 'nokogiri'

base_url = "https://www.congress.gov/search?searchResultViewType=expanded&q={%22source%22:%22legislation%22,%22bill-status%22:%22law%22}&pageSize=250&page="
browser = Watir::Browser.new :firefox

pg_num = 2
50.times do
  url =  base_url + pg_num.to_s
  browser.goto url
  sleep(2)
  lis = []
  list = browser.elements(tag_name: "li", class: "expanded")

  list.each do |li|
    link_to_txt = li.links.first.href
    years = li.text.split("Congress")[1].split("\n")[0].gsub(" (", "").gsub(")","")
    file_name = li.links.first.text.gsub(".", "_")
    path = "./" + years + "/" + file_name + ".txt"

    lis << [link_to_txt, path, years]
  end

  lis.each do |li|
    link_to_txt = li[0]
    path = li[1]
    years = li[2]
    puts "Pg num: #{pg_num}  Working on #{path}"

    browser.goto link_to_txt
    sleep(1)
    browser.element(tag_name: "nav", id: "tabs").links[1].click

    bill_text_container = browser.element(tag_name: "pre", id: "billTextContainer")
    if bill_text_container.present?
      text = bill_text_container.text
      FileUtils.mkdir_p years
      File.write(path, text)
    end
  end

  pg_num += 1
end

=begin
Pg num: 7  Working on ./2009-2010/H_R_4314.txt
Traceback (most recent call last):
	12: from bill_scraper.rb:9:in `<main>'
	11: from bill_scraper.rb:9:in `times'
	10: from bill_scraper.rb:25:in `block in <main>'
	 9: from bill_scraper.rb:25:in `each'
	 8: from bill_scraper.rb:33:in `block (2 levels) in <main>'
	 7: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:153:in `click'
	 6: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:802:in `element_call'
	 5: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:838:in `check_condition'
	 4: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:702:in `wait_for_enabled'
	 3: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:677:in `wait_for_exists'
	 2: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:678:in `wait_for_exists'
	 1: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/wait.rb:125:in `wait_until'
/Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/wait.rb:46:in `until': timed out after 30 seconds, waiting for true condition on #<Watir::HTMLElement: located: false; {:tag_name=>"nav", :id=>"tabs"}> (Watir::Wait::TimeoutError)
	11: from bill_scraper.rb:9:in `<main>'
	10: from bill_scraper.rb:9:in `times'
	 9: from bill_scraper.rb:25:in `block in <main>'
	 8: from bill_scraper.rb:25:in `each'
	 7: from bill_scraper.rb:33:in `block (2 levels) in <main>'
	 6: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:153:in `click'
	 5: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:802:in `element_call'
	 4: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:838:in `check_condition'
	 3: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:702:in `wait_for_enabled'
	 2: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:677:in `wait_for_exists'
	 1: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:676:in `wait_for_exists'
/Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:681:in `rescue in wait_for_exists': timed out after 30 seconds, waiting for #<Watir::HTMLElement: located: false; {:tag_name=>"nav", :id=>"tabs"}> to be located (Watir::Exception::UnknownObjectException)
	7: from bill_scraper.rb:9:in `<main>'
	6: from bill_scraper.rb:9:in `times'
	5: from bill_scraper.rb:25:in `block in <main>'
	4: from bill_scraper.rb:25:in `each'
	3: from bill_scraper.rb:33:in `block (2 levels) in <main>'
	2: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:153:in `click'
	1: from /Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:805:in `element_call'
/Users/phi/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/watir-6.17.0/lib/watir/elements/element.rb:813:in `rescue in element_call': timed out after 30 seconds, waiting for #<Watir::HTMLElement: located: false; {:tag_name=>"nav", :id=>"tabs"}> to be located (Watir::Exception::UnknownObjectException)
=end
