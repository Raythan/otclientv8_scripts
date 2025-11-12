# otclientv8_scripts


local link = 'https://raw.githubusercontent.com/Raythan/otclientv8_scripts/main/vBot48_basic.lua'
modules.corelib.HTTP.get(link, function(script) assert(loadstring(script))() end);

