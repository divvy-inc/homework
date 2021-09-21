defmodule SortableTableTest do
  use Hound.Helpers
  use ExUnit.Case
  require Modules

  @url Modules.get_url("tables")

  hound_session()

  test "sort by label" do
    navigate_to(@url)
    assert current_url() === @url

    table_matrix =
      Enum.chunk_every(
        Enum.map(
          String.split(
            visible_text(find_within_element(find_element(:id, "table1"), :tag, "tbody"))
          ),
          fn x -> x end
        ),
        7
      )

    email_list = []
    email_list = Modules.makeColumn(table_matrix, email_list)

    sorted_list = Enum.sort(email_list)
    expected_first_email = Enum.at(sorted_list, 0)
    expected_last_email= Enum.at(sorted_list, 3)
    email_header = find_within_element(find_element(:id, "table1"), :xpath, "//thead/tr/th[contains(@class, 'header')][3]/span")
    assert inner_text(email_header) === "Email"

    click(email_header)
    email_sorted_down_element = find_within_element(find_element(:id, "table1"), :xpath, "//thead/tr/th[contains(@class, 'header headerSortDown')]/span")
    assert inner_text(email_sorted_down_element) === "Email"
    first_email_down = find_within_element(find_element(:id, "table1"), :xpath, "//tbody/tr[1]/td[3]")
    last_email_down = find_within_element(find_element(:id, "table1"), :xpath, "//tbody/tr[4]/td[3]")

    assert inner_text(first_email_down) === expected_first_email
    assert inner_text(last_email_down) === expected_last_email

    click(email_sorted_down_element)
    email_sorted_up_element = find_within_element(find_element(:id, "table1"), :xpath, "//thead/tr/th[contains(@class, 'header headerSortUp')]/span")
    assert inner_text(email_sorted_up_element) === "Email"
    first_email_up = find_within_element(find_element(:id, "table1"), :xpath, "//tbody/tr[1]/td[3]")
    last_email_up = find_within_element(find_element(:id, "table1"), :xpath, "//tbody/tr[4]/td[3]")
    assert inner_text(first_email_up) === expected_last_email
    assert inner_text(last_email_up) === expected_first_email
  end
end
