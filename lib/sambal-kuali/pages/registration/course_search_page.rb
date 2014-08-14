class CourseSearchPage < LargeFormatRegisterForCourseBase

  page_url "#{$test_site}/registration/#/myCart"

  def go_to_results_page (search_string)
    new_url = "#{$test_site}/registration/index.jsp#/search/#{search_string}"
    @browser.goto new_url
    course_input_div.wait_until_present
  end

  # Search input
  element(:course_input_div){ |b| b.div(class: "kscr-Responsive-searchFormWrapper kscr-SearchForm") }
  element(:course_input){ |b| b.text_field(id: "courseSearchCriteria") }
  element(:course_input_button) { |b| b.button(id: "searchSubmit") }
  action(:begin_course_search) { |b| b.course_input_button.click}

  # Add to Cart
  element(:course_code_input) { |b| b.text_field(id: "courseCode") }
  element(:reg_group_code_input) { |b| b.text_field(id: "regCode") }
  element(:add_to_cart_toggle) { |b| b.div(id: "add_to_cart") }
  action(:toggle_add_dialog) { |b| b.add_to_cart_toggle.click }
  element(:submit_button) { |b| b.button(id: "submit") }
  action(:add_to_cart) { |b| b.submit_button.click }

  # Course cards
  element(:remove_course_button) { |course_code,reg_group_code,b| b.button(id: "remove_#{course_code}_#{reg_group_code}") }
  element(:course_code) { |course_code,reg_group_code,b| b.span(id: "course_code_#{course_code}_#{reg_group_code}") }

# EDIT COURSE OPTIONS DIALOG
#   context = newItem or cart
  element(:credits_selection_div) { |course_code,reg_group_code,context,b| b.div(id:"#{context}_credits_#{course_code}_#{reg_group_code}") }
  element(:credit_options_more) { |course_code,reg_group_code,context,b| b.div(id: "#{context}_credits_#{course_code}_#{reg_group_code}_more") }
  action(:more_credit_options) { |course_code,reg_group_code,context,b| b.credit_options_more(course_code,reg_group_code,context).click }
  element(:credits_selection) { |course_code,reg_group_code,credits,context,b| b.i(id: "#{context}_credits_#{course_code}_#{reg_group_code}_#{credits}") }
  action(:select_credit_count) { |course_code,reg_group_code,credits,context,b| b.credits_selection(course_code,reg_group_code,credits,context).click }
  element(:grading_audit) { |course_code,reg_group_code,context,b| b.i(id: "#{context}_grading_#{course_code}_#{reg_group_code}_Audit") }
  element(:grading_letter) { |course_code,reg_group_code,context,b| b.i(id: "#{context}_grading_#{course_code}_#{reg_group_code}_Letter") }
  element(:grading_pass_fail) { |course_code,reg_group_code,context,b| b.i(id: "#{context}_grading_#{course_code}_#{reg_group_code}_Pass/Fail") }
  element(:edit_save_button) { |course_code,reg_group_code,context,b| b.button(id: "#{context}_save_#{course_code}_#{reg_group_code}") }
  action(:save_edits) { |course_code,reg_group_code,context,b| b.edit_save_button(course_code,reg_group_code,context).click }
  element(:edit_cancel_button) { |course_code,reg_group_code,context,b| b.button(id: "#{context}_cancel_#{course_code}_#{reg_group_code}") }
  action(:cancel_edits) { |course_code,reg_group_code,context,b| b.edit_cancel_button(course_code,reg_group_code,context).click }


  # Facets
  element(:seats_avail_facet_div){ |b| b.div(id: "search_facet_seatsAvailable") }
  element(:seats_avail_toggle) { |b| b.li(id: "search_facet_seatsAvailable_option_Seatsavailable") }
  element(:clear_seats_avail_facet) { |b| b.div(id: "search_facet_clear_seatsAvailable") }
  action(:toggle_seats_avail) { |b| b.seats_avail_toggle.click }
  element(:seats_avail_count) { |b| b.seats_avail_toggle.span(index: 1).text }
  element(:credits_toggle) { |credits, b| b.li(id: "search_facet_creditOptions_option_#{credits}") }
  action(:toggle_credits) { |credits, b| b.credits_toggle(credits).click }
  element(:course_level_toggle) { |course_level,b| b.li(id: "search_facet_courseLevel_option_#{course_level}") }
  action(:toggle_course_level) { |course_level,b| b.course_level_toggle(course_level).click }
  element(:course_prefix_toggle) { |course_prefix,b| b.li(id: "search_facet_coursePrefix_option_#{course_prefix}") }
  action(:toggle_course_prefix) { |course_prefix,b| b.course_prefix_toggle(course_prefix).click }
  element(:clear_level_facet) { |b| b.div(id: "search_facet_clear_courseLevel") }
  element(:clear_prefix_facet) { |b| b.div(id: "search_facet_clear_coursePrefix") }
  element(:clear_credit_facet) { |b| b.div(id: "search_facet_clear_creditOptions") }

  # Results
  element(:search_results_summary_div) { |b| b.div(id: "search_results_summary") }
  element(:search_results_summary) { |b| b.search_results_summary_div.text }
  element(:display_limit_select) { |b| b.select(id: "display_limit_select") }
  element(:results_table) { |b| b.table(id: "search_results_table") }
  element(:sort_selector) { |column,b| b.i(id: "sort_selector_#{column}") }
  action(:sort_results_by) { |column,b| b.sort_selector(column).click }
  element(:course_code_result_link) { |course_code,b| b.tr(id: "course_detail_row_#{course_code}").td(index: 0).span }
  element(:row_result_link) { |result_row,b| result_row.td(index: 0).span }

  # Pagination
  element(:first_page_on) { |b| b.a(id: "firstPageLink") }
  element(:first_page_off) { |b| b.span(id: "firstPage") }
  action(:first_page) { |b| b.first_page_on.click }
  element(:previous_page_on) { |b| b.a(id: "prevPageLink") }
  element(:previous_page_off) { |b| b.span(id: "prevPage") }
  action(:previous_page) { |b| b.previous_page_on.click }
  element(:next_page_on) { |b| b.a(id: "nextPageLink") }
  element(:next_page_off) { |b| b.span(id: "nextPage") }
  action(:next_page) { |b| b.next_page_on.click }
  element(:last_page_on) { |b| b.a(id: "lastPageLink") }
  element(:last_page_off) { |b| b.span(id: "lastPage") }
  action(:last_page) { |b| b.last_page_on.click }

  # Details view
  element(:back_to_search_results) { |b| b.a(id: "returnToSearch") }
  element(:course_description) { |b| b.div(id: "courseDescription").text }

  # Results table column indexes
  COURSE_SEATS_INDICATOR = 0
  COURSE_CODE = 1
  COURSE_DESC = 2
  COURSE_CRED = 3

  #Gives the digit for course level comparison, eg ENGL200 would have 2 extracted and compared
  value(:courseLevel){ |row,b| row.cells[COURSE_CODE].text.slice(4,1) }

  def target_result_row_by_course(course_code)
    results_table.rows.each do |row|
      return row if row.cells[COURSE_CODE].text.match course_code
    end
    return nil
  end

  def course_desc_link_by_course (course_code)
    row = target_result_row_by_course (course_code)
    row.cells[COURSE_DESC].link
  end

  def course_prefix_by_row(row)
    row.cells[COURSE_CODE].text.slice(0,4)
  end

  def seats_avail_count_number
    seats_avail_count.match('(\d)')[1].to_i
  end


  def show_add_dialog
    toggle_add_dialog unless submit_button.visible?
  end

  def hide_add_dialog
    toggle_add_dialog if submit_button.visible?
  end

  def show_course_details(course_code, reg_group_code)
    sleep 1
    toggle_course_details(course_code,reg_group_code) unless remove_course_button(course_code,reg_group_code).visible?
  end

  def remove_course_from_cart(course_code, reg_group_code)
    remove_course_button(course_code,reg_group_code).click
  end

  def toggle_course_details(course_code, reg_group_code)
    course_code(course_code,reg_group_code).click
  end


  def results_list (column=COURSE_CODE)
    heading_text = case column
                     when COURSE_CODE then "Code"
                     when COURSE_DESC then "Title"
                     when COURSE_CRED then "Credits"
                   end
    list = []
    no_of_rows = get_results_table_rows_no - 1
    (0..no_of_rows).each { |index| list << get_table_row_value(index, column).upcase }
    list.delete_if { |item| item == heading_text.upcase }
    list.delete_if {|item| item == "" }
    list
  end
  
  def results_all_pages (column=COURSE_CODE)
    complete_list = []
    first_page if first_page_on.visible?
    if next_page_on.visible?
      until next_page_off.visible?
        partial_list = results_list column
        complete_list.concat(partial_list)
        next_page_on.wait_until_present
        next_page
        wait_until { next_page_on.visible? || next_page_off.visible? }
      end
      partial_list = results_list column
      complete_list.concat(partial_list)
      wait_until { next_page_on.visible? || next_page_off.visible? }
    else
      complete_list = results_list
    end
    complete_list
  end

  def get_table_row_value(index,column,rescues=0)
    begin
      column_name = case column
                      when COURSE_CODE then "code"
                      when COURSE_DESC then "title"
                      when COURSE_CRED then "credits"
                    end
      code = results_table.rows[index].cells[column].text
      return code
    rescue => e
      rescues = rescues+1
      puts "Retrieve #{column_name} for row #{index} rescue from #{e.message}: #{rescues}"
      if rescues<5
        sleep(1)
        get_table_row_value(index,column,rescues)
      else
        puts "Failed to retrieve #{column_name} for row #{index}"
        return ""
      end
    end
  end

  # Get number of data table rows safely
  def get_results_table_rows_no(rescues=0)
    begin
      sleep(2)
      return results_table.rows.length
    rescue => e
      rescues = rescues+1
      puts "Retrieve length rescue from #{e.message}: #{rescues}"
      if rescues<5
        return get_results_table_rows_no(rescues)
      else
        puts "Failed to retrieve length"
        return 0
      end
    end
  end

  def results_list_courses (expected)
    trimmed_array_list= Array.new
    results_list
    if expected.length == 4 || expected.length > 4 && expected[4] == ','
      trimmed_array_list<<results_list.map! {|x| x.slice(0,4) }
    elsif expected.length == 5
      trimmed_array_list<<results_list.map! {|x| x.slice(0,5) }
    else
      trimmed_array_list<<results_list.map! {|x| x }
    end
    trimmed_array_list
  end

end
