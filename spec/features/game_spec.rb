require 'spec_helper'

describe 'games' do
  let(:game_number) { 10 }

  before(:all) do

    puts "\n*** NN TRG ***\n\n"
    visit "/"
    click_link "New Game"
    select "BoardStateOnlyOpponent", :from => "game_player_x"
    select "BoardStateWithResultOpponent", :from => "game_player_o"
    click_button "Create Game"
    expect(page).to have_text("Game ended")

  end
  
  after(:all) do
    # Analyse results table
    puts "\n\n****************************"
    puts "Hmm...so what do we do here?"
    puts "****************************"
    
    puts Game::PLAYER_RESULTS_MAP
    
    totalGames = Result.all.count
    puts "\nTotal games \t\t\t\t#{totalGames}"
    
    #random = Result.where("random is not null").count
    #puts "Random played \t\t\t\t#{random}"
    
    # 6/6/14 DH: Need to create hash array to loop through game permutations...
    subtotal1 = getResults(first: "random", second: "statewithresult")
    subtotal2 = getResults(first: "statewithresult", second: "random")
    subtotal3 = getResults(first: "state", second: "statewithresult")
    
    # 6/6/14 DH: results table not have duplicate columns for each player to store result of playing yourself!
    subtotal4 = getResults(first: "random", second: "random")
    
    subtotal = subtotal1 + subtotal2 + subtotal3 + subtotal4
    if ( subtotal != totalGames)
      puts "\nSubtotal of #{subtotal} does not equal total of #{totalGames}"
    end
    
  end

  # Results = first win, second win, draw
  
  # *Random v BoardStateWithResult
  # *BoardStateWithResult v Random               (Should do better going first)
  # Random v Random                             (First should do better)
  # BoardStateWithResult v BoardStateWithResult (First should do better)
  # *BoardStateOnly v BoardStateWithResult
  # BoardStateWithResult v BoardStateOnly       (Should do better going first)

  it "BoardStateOnly vs BoardStateWithResult" do

    game_number.times.each do |number| 
      puts "\n*** GAME 1-#{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "BoardStateOnlyOpponent", :from => "game_player_x"
      select "BoardStateWithResultOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")

      notice = find("p#notice").text
      #puts "\nNotice: #{notice}\n\n"
      path = page.current_path
      gameID = path.split('/')[2]

      #puts "Winner of game #{gameID} = #{Game::PLAYER_MAP[Game.find(gameID).game_outcome]}"
    end
    
    #getResults(first: "state", second: "statewithresult")

  end

  it "Random vs BoardStateWithResult" do

    game_number.times.each do |number| 
      puts "\n*** GAME 2-#{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "RandomOpponent", :from => "game_player_x"
      select "BoardStateWithResultOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")

    end
    
    #getResults(first: "random", second: "statewithresult")

  end

  it "BoardStateWithResult vs Random" do

    game_number.times.each do |number| 
      puts "\n*** GAME 3-#{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "BoardStateWithResultOpponent", :from => "game_player_x"
      select "RandomOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")

    end
    
    #getResults(first: "statewithresult", second: "random")

  end
  
  def getResults(args = {})
    #puts args[:first]
    #puts args[:second]
    
    player1 = Game::PLAYER_RESULTS_MAP.key(args[:first])
    player2 = Game::PLAYER_RESULTS_MAP.key(args[:second])
    
    if player1.eql?(player2)
      puts "\nNot got around to creating a 'self' column in the 'results' table (for when any of the players plays himself)..."
      return 0
    end

    subtotalGames = Result.where("first = ? and #{args[:first]} is not null and #{args[:second]} is not null",args[:first]).count
    #puts "\nSub-Total games \t\t\t\t\t\t\t#{subtotalGames}"
    printf "\nSub-Total games %62d\n", subtotalGames

    firstWin = Result.where("first = ? and #{args[:first]} = ?",args[:first], 1).count
    firstWinPercent = (Float(firstWin) / subtotalGames * 100).round(1)
    #puts "#{player1} won \t\t\t\t\t\t#{firstWin} (#{firstWinPercent}%)[FIRST]"
    printf "%-30s won %43d (%.1f %%) [FIRST]\n", player1,firstWin,firstWinPercent
    
    secondWin = Result.where("first = ? and #{args[:second]} = ?",args[:first], 1).count
    secondWinPercent = (Float(secondWin) / subtotalGames * 100).round(1)
    #puts "#{player2} won \t\t\t\t\t#{secondWin} (#{secondWinPercent}%)[SECOND]"
    printf "%-30s won %43d (%.1f %%) [SECOND]\n", player2,secondWin,secondWinPercent
    
    draw = Result.where("first = ? and #{args[:first]} = ? and #{args[:second]} = ?",args[:first],0,0).count
    drawPercent = (Float(draw) / subtotalGames * 100).round(1)
    #puts "#{player1} drew against #{player2}\t#{draw} (#{drawPercent}%)"
    printf "%-30s drew against %-30s %3d (%.1f %%)\n", player1,player2,draw,drawPercent
    
    totalPercent = (firstWinPercent + secondWinPercent + drawPercent).round(2)
    puts "Total percentage = #{totalPercent}%"

=begin    
    stateFirst = Result.where("first = ?","state").count
    puts "\nState went first \t\t\t#{stateFirst}"
=end
    
    if firstWin + secondWin + draw == subtotalGames
      puts "[Well that figures]"
    else
      puts "[Doh!  Something went wrong there...]"
    end
    
    # 6/6/14 DH: Return subtotal for tallying up total
    subtotalGames

  end

end