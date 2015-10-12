# Be sure to restart your server when you modify this file.

# 12/10/15 DH: Upgrade to Ruby2.2/Rails4.2 
#Tictactoe::Application.config.session_store :encrypted_cookie_store, key: '_tictactoe_session'
Tictactoe::Application.config.session_store :cookie_store, key: '_tictactoe_session'

