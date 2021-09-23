defmodule Reuseables do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  #general selectors
  def logoutButton() do find_element(:xpath, "//i[contains (text() , 'Logout')]") end
  def loginButton() do find_element(:xpath, "//i[contains (text() , 'Login')]") end

  def login(username, pswdOverride) do

    #goes to the login url if not there already
    url = "https://the-internet.herokuapp.com/login"
    if current_url() != url do
      navigate_to url
    end

    #define selectors
    nameField = find_element(:xpath, "//*[@name = 'username']")
    pswdField = find_element(:name, "password")
    #loginButton = find_element(:xpath, "//i[contains (text() , 'Login')]")

    fill_field(nameField, username)

    #for testing purposes password is typically the same so will enter default password unless you override it
    if pswdOverride === nil do
      fill_field(pswdField, "SuperSecretPassword!")
    else
      fill_field(pswdField, pswdOverride)
    end

    click(loginButton())

  end

  def letterBoxDragDrop(start, stop) do

    #define selectors
    firstLetterBox = find_element(:xpath, "//header[text() = '#{start}']")
    secondLetterBox = find_element(:xpath, "//header[text() = '#{stop}']")

    orderOpt1 = "//header[text() = '#{start}']/../following-sibling::div/header[text() = '#{stop}']"
    orderOpt2 = "//header[text() = '#{stop}']/../following-sibling::div/header[text() = '#{start}']"
    #finds what the new order should be
    orderNew = if element_displayed?(find_element(:xpath, orderOpt1)) do
                    orderOpt2
                  else
                    orderOpt1
                  end
    #click(firstLetterBox)
    move_to(firstLetterBox, 1, 1)
    :timer.sleep(1000)
    mouse_down()
    :timer.sleep(1000)
     move_to(secondLetterBox, 1, 1)
    :timer.sleep(1000)
    mouse_up()

    assert element_displayed?(find_element(:xpath, orderNew))

  end

end
