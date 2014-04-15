require 'net/http'
require 'rubygems'
require 'json/ext'

class String
    def method_missing(m, *args, &block)
        if (m == :force_encoding) then
            return self
        end
        super.method_missing(m, args, block)
    end
end

main_json_string = Net::HTTP.get(URI('http://wolnelektury.pl/api/books/'))

json = JSON.parse(main_json_string)
p json.size

i = 0
json.each { |book|
    if (i > 100) then 
        break
    end

    book_api = book['href']
    response = Net::HTTP.get_response(URI(book['href']))
    book_json = JSON.parse(response.body.force_encoding('UTF-8'))
    book_file_name = (/^.*\/([^\/]+)\/$/.match(book['href']))[1]
    response = Net::HTTP.get_response(URI(book_json['txt'])) 
    book_txt = response.body.force_encoding('UTF-8')

    epochs = book_json['epochs'].collect { |e| e['name'] }
    authors = book_json['authors'].collect { |a| a['name'] }
    kinds = book_json['kinds'].collect { |k| k['name'] }
    genres = book_json['genres'].collect { |g| g['name'] }
    url = book['url']

    p "#{i} Saving document: #{book_file_name}"
    open("homedir/documents/#{book_file_name}.txt", "w") { |file|
        file.write(book_txt)
    }

    i += 1
    sleep(rand())
}
