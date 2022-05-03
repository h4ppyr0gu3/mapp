# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

* yewtu.be
vid.puffyan.us 
* invidious.snopyta.org 
* invidious.kavin.rocks 
inv.riverside.rocks 	
* invidious-us.kavin.rocks 
invidious.osi.kr 
y.com.sb 
tube.cthd.icu
invidious.flokinet.to
yt.artemislena.eu 	
invidious.lunar.icu
invidious.mutahar.rocks 	
invidious.se...ivacy.com 
invidious.weblibre.org 	
invidious.es...elbob.xyz 	
youtube.076.ne.jp 	
invidious.privacy.gd
inv.bp.mutahar.rocks
invidious.namazso.eu

https://api.invidious.io/

uri = URI("https://api.invidious.io/instances.json")
res = Net::HTTP.get(uri)
parsed = JSON.parse(res)
parsed.each do |k, v|
parsed["api"]
     arr << v["uri"]
   end
 end
