defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  Code.require_file("reuseableCode/reuseables.exs")

  # Start hound session and destroy when tests are run
  hound_session()

  test "tries login with wrong username, wrong password, and right credentials" do

    credValue = %{:goodName => "tomsmith", :badName => "wrong name", :badPswd => "worstpasswordever"}
    Reuseables.login(credValue[:badName], nil)
    #verifies username validation message
    assert element_displayed?(find_element(:xpath, "//*[contains (text() , 'Your username is invalid!')]"))
    Reuseables.login(credValue[:goodName], credValue[:badPswd])
    #verifies password validation message
    assert element_displayed?(find_element(:xpath, "//*[contains (text() , 'Your password is invalid!')]"))
    Reuseables.login(credValue[:goodName], nil)
    #verifies login was successful
    assert element_displayed?(find_element(:xpath, "//*[contains (text() , 'You logged into a secure area!')]"))
    click(Reuseables.logoutButton())
    #verifies logout was successful
    assert element_displayed?(Reuseables.loginButton())

  end

end
