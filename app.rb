require 'json'

# The account manager
class AccountManager
  attr_reader :accounts
  def initialize(file_path)
    @accounts = []
    load_accounts(file_path)
  end

  # This is the load accounts function
  def load_accounts(file_path)
    if File.exist?(file_path)
      @accounts = JSON.parse(File.read(file_path))
    end
  end

  # This is the save accounts function
  def save_accounts(file_path)
    File.write(file_path, JSON.pretty_generate(@accounts))
  end


# This is our create an account function
  def create_account(username, password)
    new_account = {
      "username" => username,
      "password" => password
    }
    @accounts << new_account
    save_accounts("accounts.json")
  end

# This is our view accounts function
  def view_accounts
    #Clear our terminal screen here in order to view our accounts in a clean manner.
    print "\e[2J\e[f"

    if @accounts.empty?
      puts "No accounts available."
    else
      puts "Here are all the accounts:"

      puts "+------------+------------+"
      puts "|  Username  |  Password  |"
      puts "+------------+------------+"

      # Our header function
    @accounts.each_with_index do |account, index|
      display_username = account['username'].ljust(10)[0..9]
      display_password = account['password'].ljust(10)[0..9]

      puts "| #{display_username} | #{display_password}| "

      puts "+----------------+-----------------"
    end
    end

    # Option added here so that we can get back to our main menu
    print "\nPress any key to go back to the main menu"
    gets
  end

  # This is our function for updating our account
  def update_account(username, new_info)
    account = @accounts.find { |acc| acc['username'] == username }
    if account
      new_info.each do |key, value|
        account[key] = value unless value.nil? || value.empty?
      end
      puts "Account updated successfully."
      save_accounts("accounts.json")
    else
      puts "Account not found."
    end
  end


# This is the function we created to delete our account
  def delete_account(username)
    account = @accounts.find { |acc| acc['username'] == username }
    if account
      @accounts.delete(account)
      puts "Account deleted successfully."
      save_accounts("accounts.json")
    else
      puts "Account not found."
    end
  end
end


# This is where the magic happens
def main
  manager = AccountManager.new("accounts.json")

  loop do
    # The below function will clear the terminal screen before displaying the main menu
    system("clear") || system("cls")

    puts "\nAccount Manager Menu:"
    puts "1. Create Account"
    puts "2. View Accounts"
    puts "3. Update Account"
    puts "4. Delete Account"
    puts "5. Exit"
    print "Please select an option: "
    choice = gets.chomp

    case choice
    when '1'
      print "Enter Username: "
      username = gets.chomp
      print "Enter Password: "
      password = gets.chomp
      manager.create_account(username, password)
      puts "Account created."
    when '2'
      manager.view_accounts
    when '3'
      # Display our accounts on the screen so we can give the user a visualization of what account they want to update.
      puts "\nList of Updatable Accounts:"
      # Header
      puts "+------------+------------+"
      puts "|  Username  |  Password  |"
      puts "+------------+------------+"

      # Our header function
      manager.accounts.each_with_index do |account, index|
        display_username = account['username'].ljust(10)[0..9]
        display_password = account['password'].ljust(10)[0..9]
        puts "| #{display_username} | #{display_password} |"
        puts "+------------+------------+"
      end  # This 'end' closes the 'each_with_index' block

      print "Enter Username to update: "
      username = gets.chomp
      print "Enter new Username (leave blank to keep unchanged): "
      new_username = gets.chomp
      print "Enter new Password (leave blank to keep unchanged): "
      new_password = gets.chomp
      manager.update_account(username, {'username' => new_username, 'password' => new_password})
    when '4'
      # Display our accounts on the screen so the user can choose what account to delete
      puts "\nHere is a list of accounts that you can delete."

      # Header
      puts "+------------+------------+"
      puts "|  Username  |  Password  |"
      puts "+------------+------------+"

      # Our header function
      manager.accounts.each_with_index do |account, index|
        display_username = account['username'].ljust(10)[0..9]
        display_password = account['password'].ljust(10)[0..9]
        puts "| #{display_username} | #{display_password} |"
        puts "+------------+------------+"
      end

      print "Enter Username to delete: "
      username = gets.chomp
      manager.delete_account(username)
    when '5'
      puts "Exiting... Goodbye!"
      break
    else
      puts "Invalid option. Please try again."
    end
  end
end

# Start the app
main
