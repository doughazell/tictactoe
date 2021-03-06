require 'spec_helper'

describe 'games' do
  let(:game_number) { 1 }

=begin
  before(:all) do

    puts "\n*** NN TRG ***\n\n"
    visit "/"
    click_link "New Game"
    select "BoardStateOnlyOpponent", :from => "game_player_x"
    select "BoardStateWithResultOpponent", :from => "game_player_o"
    click_button "Create Game"
    expect(page).to have_text("Game ended")

  end
=end
  
  after(:all) do
    # Analyse results table
    puts "\n\n"
    puts "****************************"
    puts "Hmm...so what do we do here?"
    puts "****************************"
    
    puts Game::PLAYER_RESULTS_MAP
    
    totalGames = Result.all.count
    puts "\nTotal games #{totalGames}"
    
    #random = Result.where("random is not null").count
    #puts "Random played \t\t\t\t#{random}"
    
    gameSet = [
      {first: "state",           second: "statewithresult"},
      {first: "statewithresult", second: "state"},
      
      {first: "random",          second: "statewithresult"},
      {first: "statewithresult", second: "random"},
      
      {first: "random",          second: "state"},
      {first: "state",           second: "random"},      

      {first: "random",          second: "random"},
      
      {first: "statewithresult", second: "statewithresult"},
      {first: "statewithresult", second: "stateresult"},
      {first: "stateresult", second: "statewithresult"}
    ]
    
    subtotal = 0
    gameSet.each do |game|
      # 14/8/14 DH: SQLite requires numerical date format (PostgreSQL supports normal written dates)
      
      # 3/10/14 DH: Left in after getting results in 'getResults' after a specified date as an idea to 
      #             reuse the 'stateresult' column whilst exploring the necessary training data.
      game[:date] = '2014-08-10'
      
      #subtotal += getResults(game)
      
      # 16/10/14 DH: Converting the results stats to use the original Games table (that actually contains all the needed info)
      subtotal += getGameResults(game)
    end
    
    if (subtotal != totalGames)
      puts "\nSubtotal of #{subtotal} in 'games' does not equal total of #{totalGames} in 'results'!"
    end
    
  end

  # Results = first win, second win, draw
  
  # *BoardStateOnly v BoardStateWithResult
  # *BoardStateWithResult v BoardStateOnly       (Should do better going first)
  # *Random v BoardStateWithResult
  # *BoardStateWithResult v Random               (Should do better going first)
  # *BoardStateOnly v Random
  # *Random v BoardStateOnly
  # *Random v Random                             (First should do better)
  # *BoardStateWithResult v BoardStateWithResult  (First should do better)
  # *BoardStateWithResult v BoardStateResult      (Find effect of longer trg)
  # *BoardStateResult v BoardStateWithResult      (Find more about shorter trg)
  
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

  it "BoardStateWithResult vs BoardStateOnly" do

    game_number.times.each do |number| 
      puts "\n*** GAME 2-#{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "BoardStateWithResultOpponent", :from => "game_player_x"
      select "BoardStateOnlyOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")

    end

  end


  it "Random vs BoardStateWithResult" do

    game_number.times.each do |number| 
      puts "\n*** GAME 3-#{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "RandomOpponent", :from => "game_player_x"
      select "BoardStateWithResultOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")

    end

  end

  it "BoardStateWithResult vs Random" do

    game_number.times.each do |number| 
      puts "\n*** GAME 4-#{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "BoardStateWithResultOpponent", :from => "game_player_x"
      select "RandomOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")

    end

  end

  it "Random vs BoardStateOnly" do

    game_number.times.each do |number| 
      puts "\n*** GAME 5-#{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "RandomOpponent", :from => "game_player_x"
      select "BoardStateOnlyOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")

    end

  end

  it "BoardStateOnly vs Random" do

    game_number.times.each do |number| 
      puts "\n*** GAME 6-#{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "BoardStateOnlyOpponent", :from => "game_player_x"
      select "RandomOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")

    end

  end

  it "Random vs Random" do

    game_number.times.each do |number| 
      puts "\n*** GAME 7-#{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "RandomOpponent", :from => "game_player_x"
      select "RandomOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")

    end

  end

  it "BoardStateWithResult vs BoardStateWithResult" do

    game_number.times.each do |number| 
      puts "\n*** GAME 8-#{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "BoardStateWithResultOpponent", :from => "game_player_x"
      select "BoardStateWithResultOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")

    end

  end

  it "BoardStateWithResult vs BoardStateResult" do

    game_number.times.each do |number| 
      puts "\n*** GAME 9-#{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "BoardStateWithResultOpponent", :from => "game_player_x"
      select "BoardStateResultOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")

    end

  end

  it "BoardStateResult vs BoardStateWithResult" do

    game_number.times.each do |number| 
      puts "\n*** GAME 10-#{number+1} ***\n\n"
      visit "/"
      click_link "New Game"
      select "BoardStateResultOpponent", :from => "game_player_x"
      select "BoardStateWithResultOpponent", :from => "game_player_o"
      click_button "Create Game"
      
      expect(page).to have_text("Game ended")

    end

  end

  # -----------------------------------------------------------------------------------------------------
  
  # 14/10/14 DH: Get the required results from the original game table
  def getGameResults(args = {})
    
    # 16/10/14 DH: The original player type mapping was only previously needed for the results output.
    #              Now it's needed to map the players from the game set (above) to the original games table! 
    player1 = Game::PLAYER_RESULTS_MAP.key(args[:first])
    player2 = Game::PLAYER_RESULTS_MAP.key(args[:second])
    
    # 19/10/14 DH: "||" has higher prcedence than "or"
    #
    #              I was experimenting with different training sets for the BoardStateResultOpponent so there was 
    #              inconsistency in the data before a specifed date
    if player1.eql?("BoardStateResultOpponent") || player2.eql?("BoardStateResultOpponent")
      games = Game.where("player_x = ? and player_o = ? and result_id is not null and created_at > ?",player1,player2,'2014-08-03 17:50')
    else
      games = Game.where("player_x = ? and player_o = ? and result_id is not null",player1,player2)
    end

    # FK: 'Games.result_id'
    gameIDs       = games.pluck(:result_id)    
    subtotalGames = games.count

    # 24/10/14 DH: The 'games.game_outcome' is same as player number ie 1 for X, -1 for O (and 0 for draw)    
    firstWin  = (games.where("game_outcome = 1")).count
    secondWin = (games.where("game_outcome = -1")).count
    draw      = (games.where("game_outcome = 0")).count

    getMissingIDs(args,gameIDs)
    calcPercentages(player1,player2,subtotalGames,firstWin,secondWin,draw)

    subtotalGames
  end
  
  def getMissingIDs(args,gameIDs)

    player1 = Game::PLAYER_RESULTS_MAP.key(args[:first])
    player2 = Game::PLAYER_RESULTS_MAP.key(args[:second])

    # 17/10/14 DH: The SQL needs to be diff for a self play record set in the 'results' table (but not for the 'games' table)
    #              PK: 'Results.id'
    if player1.eql?(player2)
      resultIDs = Result.where("first = ? and self is not null",args[:first]).pluck(:id)
    else
      resultIDs = Result.where("first = ? and #{args[:first]} is not null and #{args[:second]} is not null",args[:first]).pluck(:id)
    end

    if resultIDs.count > gameIDs.count
      missingIDs = resultIDs - gameIDs
      table = "games"
    else
      missingIDs = gameIDs - resultIDs
      table = "results"
    end

    if not missingIDs.empty?
      printf "\n******\n"
      printf "Missing IDs from '#{table}' table in #{player1} v #{player2}: %10s%s\n", "",missingIDs.to_s
      printf "******\n"
    end
  
  end
  
  # 14/10/14 DH: Associated results table not needed since all the information is already stored in the games table!
  def getResults(args = {})
    #puts args[:first]
    #puts args[:second]
    
    player1 = Game::PLAYER_RESULTS_MAP.key(args[:first])
    player2 = Game::PLAYER_RESULTS_MAP.key(args[:second])
    
    if player1.eql?(player2)
      subtotalGames = Result.where("first = ? and self is not null",args[:first]).count
      firstWin      = Result.where("first = ? and #{args[:first]} = ? and self = ?",args[:first], 1, 0).count
      secondWin     = Result.where("first = ? and #{args[:first]} = ? and self = ?",args[:first], 0, 1).count
      draw          = Result.where("first = ? and #{args[:first]} = ? and self = ?",args[:first], 0, 0).count
    else
      subtotalGames = Result.where("first = ? and #{args[:first]} is not null and #{args[:second]} is not null",args[:first]).count
      firstWin      = Result.where("first = ? and #{args[:first]} = ? and #{args[:second]} = ?",args[:first], 1, 0).count
      secondWin     = Result.where("first = ? and #{args[:first]} = ? and #{args[:second]} = ?",args[:first], 0, 1).count
      draw          = Result.where("first = ? and #{args[:first]} = ? and #{args[:second]} = ?",args[:first], 0, 0).count        
    end

    calcPercentages(player1,player2,subtotalGames,firstWin,secondWin,draw)
    
    # 6/6/14 DH: Return subtotal for tallying up total
    subtotalGames

  end

  def calcPercentages(player1,player2,subtotalGames,firstWin,secondWin,draw)
    #puts "\nSub-Total games \t\t\t\t\t\t\t#{subtotalGames}"
    printf "\nSub-Total games %62d\n", subtotalGames

    firstWinPercent = (Float(firstWin) / subtotalGames * 100).round(1)
    #puts "#{player1} won \t\t\t\t\t\t#{firstWin} (#{firstWinPercent}%)[FIRST]"
    
    # 17/10/14 DH: The "-" in the format string Left-justify the result
    #              http://www.ruby-doc.org/core-2.1.3/Kernel.html#method-i-format
    printf "%-30s won %43d (%.1f %%) [FIRST]\n", player1,firstWin,firstWinPercent

    secondWinPercent = (Float(secondWin) / subtotalGames * 100).round(1)
    #puts "#{player2} won \t\t\t\t\t#{secondWin} (#{secondWinPercent}%)[SECOND]"
    printf "%-30s won %43d (%.1f %%) [SECOND]\n", player2,secondWin,secondWinPercent

    drawPercent = (Float(draw) / subtotalGames * 100).round(1)
    #puts "#{player1} drew against #{player2}\t#{draw} (#{drawPercent}%)"
    printf "%-30s drew against %-30s %3d (%.1f %%)\n", player1,player2,draw,drawPercent
    
    totalPercent = (firstWinPercent + secondWinPercent + drawPercent).round(2)
    puts "Total percentage = #{totalPercent}%"

    if firstWin + secondWin + draw == subtotalGames
      puts "[Well that figures]"
    else
      puts "[Doh!  Something went wrong there...]"
    end
  
  end
  
end
