require 'discordrb'
require 'json'

config = JSON.parse(File.read('config.json'))

bot = Discordrb::Commands::CommandBot.new token: config['token'], prefix: config['prefix'], intents: :all

bot.command :ping do |event, *args|
    event.respond(event.author.mention + ', Pong! `' + ((Time.now - event.timestamp)*1000).round().to_s + ' ms`')
end

bot.run