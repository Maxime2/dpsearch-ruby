#!/usr/bin/ruby

require 'cgi'
require 'rest_client'
require 'json'

# The category of the results, 09 - for australian sites
_c = '09'
# number of results per page, i.e. how many results will be returned
_ps = 10
# result page number, starting with 0
_np = 0
# synonyms use flag, 1 - to use, 0 - don't
_sy = 0
# word forms use flag, 1 - to use, 0 - don't (search for words in query exactly)
_sp = 1
# search mode, can be 'near', 'all', 'any'
_m = 'near'
# results groupping by site flag, 'yes' - to group, 'no' - don't
_GroupBySite = 'no'
# search result template 
_tmplt = 'json2.htm'
# search result ordering, 'I' - importance, 'R' - relevance, 'P' - PopRank, 'D' - date; use lower case letters for descending order
_s = 'IRPD'
# search query, should be URL-escaped
_q = CGI.escape('careers')

response = RestClient.get('http://inet-sochi.ru:7003/', {:params => {
                   :c => _c, 
                   :ps => _ps, 
                   :np => _np, 
                   :sy => _sy, 
                   :sp => _sp, 
                   :m => _m, 
                   'GroupBysite' => _GroupBySite, 
                   :tmplt => _tmplt, 
                   :s => 'IRPD', 
                   :q => _q
                 }}){ |response, request, result, &block|

  case response.code
  when 200
#    p "It worked !"
    response
  when 423
    raise SomeCustomExceptionIfYouWant
  else
    response.return!(request, result, &block)
  end
}

result = JSON.parse(response)

result['responseData']['results'].each { |pos|
  print "#{pos['title']}\n => #{pos['url']}\n\n"
}

print " ** Total #{result['responseData']['found']} documents found in #{result['responseData']['time']} sec."
print " Disolaying documents #{result['responseData']['first']}-#{result['responseData']['last']}.\n"
