defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  @last_name "Smith"
  @first_name "John"
  @email "tester123@gmail.com" # Please test with an valid email id. I had locked my account testing this feature
  @url "https://m.facebook.com"
  @success_msg "We'll take you through a few steps to confirm your account on Facebook.."

  def navigate_to_login_page(url) do
    navigate_to(url)
    find_element(:link_text,"Create new account", 10)
  end

  def fill_firstname_and_lastname_input_field(first_name,last_name) do
    first_name_element = find_element(:name, "firstname")
    element_displayed?(first_name_element)
    fill_field(first_name_element, first_name)
    last_name_element = find_element(:name, "lastname")
    element_displayed?(first_name_element)
    fill_field(last_name_element, last_name)
    next_button_field = find_element(:xpath, "//*[@id=\"mobile-reg-form\"]/div[9]/div[2]/button[1]")
    element_displayed?(next_button_field)
    click(next_button_field)
  end

  def find_alert_message_field() do
    find_element(:id, "registration-error")
  end

  def fill_date_of_birth_field(month,day,year) do
    month = find_element(:css, "#month > option:nth-child(#{month})", 10)
    click(month)
    day = find_element(:css, "#day > option:nth-child(#{day})", 10)
    click(day)
    year = find_element(:xpath, "//*[@id=\"year\"]/option[#{year}]", 10)
    click(year)
  end

  def click_next_button_field() do
    next_button_field = find_element(:xpath, "//*[@id=\"mobile-reg-form\"]/div[9]/div[2]/button[1]")
    click(next_button_field)
  end

  def fill_contact_information(phone_number) do
    contact_input_field = find_element(:id, "contactpoint_step_input")
    input_into_field(contact_input_field, phone_number)
  end

  def select_gender(gender)do
    element = find_element(:id,gender)
    click(element)
  end

  def input_password(password) do
    password_input_field =  find_element(:xpath, "//*[@id=\"password_step_input\"]")
    input_into_field(password_input_field, password)
  end

  def signup() do
    signup_button_field = find_element(:xpath, "//*[@id=\"mobile-reg-form\"]/div[9]/div[2]/button[4]")
    click(signup_button_field)
  end

  def login_multiple_times(n) when n <= 1 do
    # click(sign_in_field)
    take_screenshot("login_attempt_failure.png")
    raise "Can't move forward"
  end

  def login_multiple_times(n) do
    email_id_field = find_element(:xpath, "//*[@id=\"m_login_email\"]")
    fill_field(email_id_field, @email)
    password_field = find_element(:xpath, "//*[@id=\"m_login_password\"]")
    fill_field(password_field, 1234)
    sign_in_field = find_element(:xpath, "//*[@id=\"login_password_step_element\"]/button")
    click(sign_in_field)
    try do
      assert page_title() == "Facebook - log in or sign up"
      login_multiple_times(n - 1)
      :timer.sleep(100)
    rescue
      _ -> take_screenshot("login_attempt_page_new.png")
    end

  end

  #Starts a hound session
  hound_session()

  @tag :account_creation_negative_test
  test "with invalid first name and last name" do
    try do
      navigate_to_login_page(@url) |> click()
      assert page_title() == "Join Facebook"
      assert visible_text(find_element(:xpath, "//*[@id=\"mobile-reg-form\"]/div[3]/div[1]/span/span")) == "What's your name?"

      #firstname empty and last name with a valid input
      fill_firstname_and_lastname_input_field(nil,@last_name)
      alert_text = find_alert_message_field()
      assert visible_text(alert_text) == "Please enter your first name."
      refresh_page()

      #last name empty and first name with a valid input
      fill_firstname_and_lastname_input_field(@first_name,nil)
      alert_text = find_alert_message_field()
      assert visible_text(alert_text) == "Please enter your last name."
    rescue
      error ->  take_screenshot("name_assertion_failure.png")
                raise error
    end

  end

  test "with valid first name and last name" do
    fb_new_account_page = navigate_to_login_page(@url)
    click(fb_new_account_page)
    assert visible_text(find_element(:xpath, "//*[@id=\"mobile-reg-form\"]/div[3]/div[1]/span/span")) == "What's your name?"
    # valid first_name and last name
    fill_firstname_and_lastname_input_field(@first_name,@last_name)
  end

  @tag :single
  @tag :account_creation_negative_test
  test "with invalid date of birth" do
    fb_new_account_page = navigate_to_login_page(@url)
    click(fb_new_account_page)
    fill_firstname_and_lastname_input_field(@first_name,@last_name)
    click_next_button_field()

    try do
      date_of_birth_text = find_element(:xpath, "//*[@id=\"mobile-reg-form\"]/div[4]/div[1]/span/div[1]", 10)
      assert visible_text(date_of_birth_text) == "What's your birthday?"
      # invalid date of birth
      fill_date_of_birth_field(10,5,2)
      registration_error = find_element(:xpath, "//*[@id=\"registration-error\"]/div", 10)
      assert(visible_text(registration_error)=="It looks like you entered the wrong info. Please be sure to use your real birthday.")
    rescue
      error ->
              take_screenshot("invalid_date_of_birth.png")
              raise error
    end
  end

  test "with valid date of birth" do
    fb_new_account_page = navigate_to_login_page(@url)
    click(fb_new_account_page)
    fill_firstname_and_lastname_input_field(@first_name,@last_name)
    date_of_birth_text = find_element(:xpath, "//*[@id=\"mobile-reg-form\"]/div[4]/div[1]/span/div[1]", 10)
    assert visible_text(date_of_birth_text) == "What's your birthday?"

    #valid date of birth
    fill_date_of_birth_field(11,11,15)
    :timer.sleep(100)
    click_next_button_field()
  end

  @tag :single
  @tag :account_creation_negative_test
  test "with empty phone number" do
    fb_new_account_page = navigate_to_login_page(@url)
    click(fb_new_account_page)
    fill_firstname_and_lastname_input_field(@first_name,@last_name)
    fill_date_of_birth_field(11,11,15)
    :timer.sleep(1000)
    click_next_button_field()


    try do
      assert(visible_text(find_element(:xpath, "//*[@id=\"contactpoint_step_title\"]/span", 10))
            == "Enter your phone number")
      fill_contact_information(nil) #empty phone number
      click_next_button_field()
      alert_text = find_element(:id, "registration-error")
      assert visible_text(alert_text) == "Please enter a valid phone number."
    rescue
      error ->  take_screenshot("phone_number_assertion_failure.png")
                raise error
    end
  end

  @tag :single
  test "with invalid phone number" do
    fb_new_account_page = navigate_to_login_page(@url)
    click(fb_new_account_page)
    fill_firstname_and_lastname_input_field(@first_name,@last_name)
    fill_date_of_birth_field(11,11,15)
    :timer.sleep(1000)
    click_next_button_field()

    try do
      page_text = visible_text(find_element(:xpath, "//*[@id=\"contactpoint_step_title\"]/span", 10))
      assert(page_text == "Enter your phone number")
      #random phone number with 7 digits
      :timer.sleep(2000)
      fill_contact_information(1234567)
      click_next_button_field()
    rescue
      error ->  take_screenshot("invalid_phone_number_assertion_failure.png")
                raise error
    end
  end

  @tag :account_creation_negative_test
  test "with no input for gender" do
    fb_new_account_page = navigate_to_login_page(@url)
    click(fb_new_account_page)
    fill_firstname_and_lastname_input_field(@first_name,@last_name)
    fill_date_of_birth_field(11,11,15)
    click_next_button_field()
    fill_contact_information(1234567)
    click_next_button_field()


    :timer.sleep(400)
    try do
      assert(visible_text(find_element(:xpath, "//*[@id=\"mobile-reg-form\"]/div[6]/div[1]/span"))
      == "What's your gender?")
      #no input for gender
      next_button_field = find_element(:xpath, "//*[@id=\"mobile-reg-form\"]/div[9]/div[2]/button[1]")
      click(next_button_field)
      alert_text = find_element(:id, "registration-error")
      assert visible_text(alert_text) == "Please select your gender."
    rescue
      error ->  take_screenshot("gender_assertion_failure.png")
                raise error
    end
  end

  test "with valid input for gender" do
    fb_new_account_page = navigate_to_login_page(@url)
    click(fb_new_account_page)
    fill_firstname_and_lastname_input_field(@first_name,@last_name)
    fill_date_of_birth_field(11,11,15)
    click_next_button_field()
    fill_contact_information(1234567)
    click_next_button_field()

    :timer.sleep(400)
    assert(visible_text(find_element(:xpath, "//*[@id=\"mobile-reg-form\"]/div[6]/div[1]/span"))
    == "What's your gender?")
    #valid input for gender to proceed to next page
    :timer.sleep(400)
    select_gender("Male")
    next_button_field = find_element(:xpath, "//*[@id=\"mobile-reg-form\"]/div[9]/div[2]/button[1]")
    click(next_button_field)
  end

  @tag :account_creation_negative_test
  test "with empty input for password field" do
    fb_new_account_page = navigate_to_login_page(@url)
    click(fb_new_account_page)
    fill_firstname_and_lastname_input_field(@first_name,@last_name)
    fill_date_of_birth_field(11,11,15)
    click_next_button_field()
    fill_contact_information(1234567)
    click_next_button_field()
    :timer.sleep(400)
    select_gender("Male")
    :timer.sleep(400)
    click_next_button_field()

    try do
      assert(visible_text(find_element(:xpath, "//*[@id=\"password_step_title\"]/span", 10))
      =="Choose a Password")

      #empty input for password
      input_password(nil)
      :timer.sleep(400)
      signup()
      alert_text = find_element(:xpath ,"//*[@id=\"registration-error\"]")
      assert visible_text(alert_text) == "Enter a combination of at least six numbers, letters and punctuation marks (like ! and &)."
    rescue
      error ->  take_screenshot("password_assertion_failure.png")
                raise error
    end
  end

  @tag :account_creation_negative_test
  test "with invalid input of 3 characters for password field" do
    fb_new_account_page = navigate_to_login_page(@url)
    click(fb_new_account_page)
    fill_firstname_and_lastname_input_field(@first_name,@last_name)
    fill_date_of_birth_field(11,11,15)
    click_next_button_field()
    fill_contact_information(1234567)
    click_next_button_field()
    :timer.sleep(400)
    select_gender("Male")
    click_next_button_field()

    assert(visible_text(find_element(:xpath, "//*[@id=\"password_step_title\"]/span", 10))
    == "Choose a Password")

    #with alpahabets 3 characters
    try do
      input_password("abc")
      signup()
      :timer.sleep(4000)
      assert visible_page_text() != "We'll take you through a few steps to confirm your account on Facebook.."
    rescue
        error -> take_screenshot("password_assertion_failure_with_alphabets.png")
                 raise error
    end
  end

  @tag :account_creation_negative_test
  test "with invalid password of length 6 characters" do
    fb_new_account_page = navigate_to_login_page(@url)
    click(fb_new_account_page)
    fill_firstname_and_lastname_input_field(@first_name,@last_name)
    fill_date_of_birth_field(11,11,15)
    click_next_button_field()
    fill_contact_information(1234567)
    click_next_button_field()
    :timer.sleep(400)
    select_gender("Male")
    click_next_button_field()
    :timer.sleep(1000)

    assert(visible_text(find_element(:xpath, "//*[@id=\"password_step_title\"]/span"))
    == "Choose a Password")

    #with 6  numbers
    try do
      input_password(123456)
      signup()
      :timer.sleep(4000)
      assert visible_page_text() != @success_msg
    rescue
      error -> take_screenshot("password_assertion_failure_with_number.png")
               raise error
    end
  end


  @tag :account_sign_in
  test "logging in with valid email and invalid password" do
    navigate_to("https://m.facebook.com/")
    login_multiple_times(25)
  end

end
