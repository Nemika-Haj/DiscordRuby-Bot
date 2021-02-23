require 'discordrb'
require 'json'

$config = JSON.parse(File.read('config.json'))

def is_manager(user)
    return $config['managers'].include?(user.id)
end

$bot = Discordrb::Commands::CommandBot.new token: $config['token'], prefix: $config['prefix'], intents: :all

$bot.command :ping do |ctx, *args|
    ctx << ctx.author.mention + ', Pong! `' + ((Time.now - ctx.timestamp)*1000).round().to_s + ' ms`'
end

$bot.command :countArgs do |ctx, *args|
    ctx << args.join(", ")
end

$bot.command :longmsg do |ctx, *args|
    ctx << "What's this"
    ctx << "Damn it works?"
    ctx << "what dis."
end

$bot.command :embedTest do |ctx, *args|
    ctx.send_embed() do |embed|
        embed.title = "OwO"
        embed.colour = 0xd127d1
        embed.description = "<3"
        embed.timestamp = Time.now()
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'Nemika', icon_url:ctx.author.avatar_url)
    end

end

$bot.command :eval do |ctx, *code|
    break unless is_manager(ctx.user)

    begin
        eval code.join(' ')
    rescue StandardError => exception
        ctx << 'The following error occured;'
        ctx << '```rb'
        ctx << exception
        ctx << '```'
    end
end

$bot.command :say do |ctx, *args|
    ctx << args.join(' ')
end

# No clue why this isn't working e
$bot.command :guessGame do |ctx, *args|
    number = rand(1..10)

    ctx << "Try to guess a random number from 1 to 10!"

    ctx.user.await!(timeout:300) do |guess|
        begin
            guess = guess.message.content.to_i 

            if guess == number
                ctx << "Congratulations! You guessed it!"
                true
            else
                ctx << guess > number ? "Too high!" : "Too low!"
                false
            end

        rescue => exception
            ctx << "Your guess must be a number!"
            
            false
        end
    end
    ctx << "The number was " + guess.to_s
end


$bot.run