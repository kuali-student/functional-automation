When /^I create an Academic Calendar$/ do
  @calendar = make AcademicCalendar
  @calendar.create
end

When /^I create an Academic Calendar in Official status$/ do
  @calendar = make AcademicCalendar
  @calendar.create
  @calendar.make_official
end

Then /^the Make Official button should become active$/ do
  on EditAcademicCalendar do |page|
    page.make_official_link.present?.should == true # TODO: Figure out why ".should_be enabled" does not work.
  end
end

When /^I search for the calendar$/ do
  @calendar.search
end

When /^I search for academic calendars$/ do
  @calendar = make AcademicCalendar, :name => "Academic Calendar"
  @calendar.search
end

When /^I search for holiday calendars$/ do
  @calendar = make HolidayCalendar, :name => "Holiday Calendar"
  @calendar.search
end

When /^I search for academic terms$/ do
  @term = make AcademicTerm, :term_name => "Term", :term_year => ""
  @term.search
end

When /^I search for the Academic Calendar using (.*)$/ do |arg|
  search_terms = { :wildcards=>"*", :"partial name"=>@calendar.name[0..2] }
  visit Enrollment do |page|
    page.search_for_calendar_or_term
  end
  on CalendarSearch do |page|
    page.search_for "Academic Calendar", search_terms[arg.to_sym]

    while page.showing_up_to.to_i < page.total_results.to_i
      if page.results_list.include? @calendar.name
        break
      else
        page.next
      end
    end
  end
end

Then /^the calendar (.*) appear in search results$/ do |arg|
  on CalendarSearch do |page|
    if arg == "should"
      page.results_list.should include @calendar.name
    else
      begin
        page.results_list.should_not include @calendar.name
      rescue Watir::Exception::UnknownObjectException
        # Implication here is that there were no search results at all.
      end
    end
  end
end

When /^I make the calendar official$/ do
  @calendar.make_official
end

Then /^the calendar (.*) be set to Official$/ do |arg|
  on CalendarSearch do |page|
    if arg == "should"
      is_official = page.calendar_action_text(@calendar.name).include? "Delete"
      is_official.should == false
    else
      is_official = page.calendar_status(@calendar.name).include? "Delete"
      is_official.should == true
    end
  end
end

When /^I copy the Academic Calendar$/ do
  @calendar_copy = make AcademicCalendar
  @calendar_copy.copy_from @calendar.name
end

When /^I update the Academic Calendar$/ do
  @calendar.search
  on CalendarSearch do |page|
    page.edit @calendar.name
  end
  @calendar.name = random_alphanums.strip
  @calendar.start_date = "02/15/#{next_year[:year]}"
  @calendar.end_date = "07/06/#{next_year[:year] + 1}"
  on EditAcademicCalendar do |page|
    page.academic_calendar_name.set @calendar.name
    page.calendar_start_date.set @calendar.start_date
    page.calendar_end_date.set @calendar.end_date
    page.save
  end
end

When /^I delete the Academic Calendar draft$/ do
  on EditAcademicCalendar do |page|
    page.delete_draft
    page.confirm_delete
  end
end

Then /^the calendar should reflect the updates$/ do
  on CalendarSearch do |page|
    page.edit @calendar.name
  end
  on EditAcademicCalendar do |page|
    page.academic_calendar_name.value.should == @calendar.name
    page.calendar_start_date.value.should == @calendar.start_date
    page.calendar_end_date.value.should == @calendar.end_date
  end
end

When /^I add a (.*) term and save$/ do |term_type|
  on EditAcademicTerms do |page|
     page.go_to_terms_tab
     @term = make AcademicTerm
     @term.create term_type
     page.go_to_cal_tab
  end
  on EditAcademicCalendar do |page|
    page.save
    raise "Page has errors" unless page.page_info_message
    if(page.page_info_message)
        (page.page_info_message_text =~ /has been saved successfully./).should_not == nil
    end
  end
end

Then /^I verify that the term added to the calendar$/ do
  @calendar.search
  on CalendarSearch do |page|
    page.edit @calendar.name
  end
  on EditAcademicTerms do |page|
    page.go_to_terms_tab
    @term.verify
  end
end

And /^Make Official button for the term is enabled$/ do
  on EditAcademicTerms do |page|
    page.term_make_official_enabled(0).should == true
    page.term_make_official_button(0).should == 'Make Official'
  end
end

And /^I make the term official$/ do
  @term.make_official
end

Then /^the term should be set to Official on edit$/ do
  @term.search
  on CalendarSearch do |page|
    page.edit @term.term_name
  end
  on EditAcademicTerms do |page|
    page.term_make_official_button(0).should == 'Update Official'
  end
end

When /^I delete the Academic Term draft$/ do
  @term.search
  on CalendarSearch do |page|
    page.edit @term.term_name
  end
  on EditAcademicTerms do |page|
    page.go_to_terms_tab
    page.delete_term(0)
    page.go_to_cal_tab
  end
  on EditAcademicCalendar do |page|
    page.save
    raise "Page has errors" unless page.page_info_message
    if(page.page_info_message)
      (page.page_info_message_text =~ /has been saved successfully./).should_not == nil
    end
  end
end

And /^the term should not appear in search results$/ do
  @term.search
  on CalendarSearch do |page|
    begin
      page.results_list.should_not include @calendar.name
    rescue Watir::Exception::UnknownObjectException
      # Implication here is that there were no search results at all.
    end
  end
end

Then /^I should be able to view the calendars$/ do
  on CalendarSearch do |page|
    begin
      # only check the visible rows of the table, and skip the header
      last_row = page.showing_up_to.to_i - 1
      page.results_table.rows[1..last_row].each do |row|
        row.link(text: "View").present?.should be_true
      end
    rescue Watir::Exception::UnknownObjectException
      # Means no search results on the page.
      raise "Page has no results to check"
    end
  end
end

And /^I should not be able to edit a calendar$/ do
  on CalendarSearch do |page|
    begin
      page.results_table.rows.each do |row|
        row.link(text: "Edit").present?.should be_false
      end
    rescue Watir::Exception::UnknownObjectException
      # Means no search results on the page.
      raise "Page has no results to check"
    end
  end
end

And /^I should not be able to copy a calendar$/ do
  on CalendarSearch do |page|
    begin
      page.results_table.rows.each do |row|
        row.link(text: "Copy").present?.should be_false
      end
    rescue Watir::Exception::UnknownObjectException
      # Means no search results on the page.
      raise "Page has no results to check"
    end
  end
end

Then /^I should be able to view the terms$/ do
  on CalendarSearch do |page|
    begin
      # only check the visible rows of the table, and skip the header
      last_row = page.showing_up_to.to_i - 1
      page.results_table.rows[1..last_row].each do |row|
        row.link(text: "View").present?.should be_true
      end
    rescue Watir::Exception::UnknownObjectException
      # Means no search results on the page.
      raise "Page has no results to check"
    end
  end
end

And /^I should not be able to edit a term$/ do
  on CalendarSearch do |page|
    begin
      page.results_table.rows.each do |row|
        row.link(text: "Edit").present?.should be_false
      end
    rescue Watir::Exception::UnknownObjectException
      # Means no search results on the page.
      raise "Page has no results to check"
    end
  end
end

When /^I add a new term to the Academic Calendar$/ do
  @term = make AcademicTerm, :term_year => @calendar.year
  @calendar.edit :terms => [ @term ]
end

When /^I add a new term to the Academic Calendar with a defined instructional period$/ do
  @term = make AcademicTerm, :term_year => @calendar.year
  @calendar.edit :terms => [ @term ]
  @term.expected_instructional_days = @term.weekdays_in_term

  @keydategroup = make KeyDateGroup, :key_date_group_type=> "Instructional", :term_type=> @term.term_type
  @keydate = create KeyDate, :parent_key_date_group => @keydategroup,
                    :key_date_type => "Instructional Period",
                    :start_date => @term.start_date,
                    :end_date => @term.end_date,
                    :date_range => true
end

Then /^the term is listed when I view the Academic Calendar$/ do
  @calendar.search

  on CalendarSearch do |page|
    page.view @calendar.name
  end

  on ViewAcademicTerms do |page|
    page.go_to_terms_tab
    page.open_term_section(@term.term_type)
    page.term_name(@term.term_type).should == @term.term_name
    #page.term_code(@term.term_type)
    page.term_start_date(@term.term_type).should == @term.start_date
    page.term_end_date(@term.term_type).should == @term.end_date
    page.term_status(@term.term_type).should == "DRAFT"
    #puts page.term_instructional_days(@term.term_type)
    #puts page.term_status(@term.term_type)
    #puts page.key_date_start(@term.term_type,"instructional","Grades Due")
    #puts page.key_date_start(@term.term_type,"registration","Last Day to Add Classes")

  end
end

Then /^the updated term information is listed when I view the Academic Calendar$/ do
  @calendar.search

  on CalendarSearch do |page|
    page.view @calendar.name
  end

  on ViewAcademicTerms do |page|
    page.go_to_terms_tab
    page.open_term_section(@term.term_type)
    page.term_name(@term.term_type).should == @term.term_name
    #page.term_code(@term.term_type)
    page.term_start_date(@term.term_type).should == @term.start_date
    page.term_end_date(@term.term_type).should == @term.end_date
    page.term_status(@term.term_type).should == "DRAFT"
    #puts page.term_instructional_days(@term.term_type)
    #puts page.term_status(@term.term_type)
    #puts page.key_date_start(@term.term_type,"instructional","Grades Due")
    #puts page.key_date_start(@term.term_type,"registration","Last Day to Add Classes")

  end
end

Given /^I copy an existing Academic Calendar$/ do
  @source_calendar = make AcademicCalendar, :name => "2012-2013 Continuing Education Calendar"
  @calendar = make AcademicCalendar
  @calendar.copy_from @source_calendar.name
end

When /^I edit the information for a term$/ do
#  @calendar.edit
  @term.edit :term_name => "CE Term1",
             :start_date => (Date.strptime( @term.start_date , '%m/%d/%Y') + 2).strftime("%m/%d/%Y"), #add 2 days
             :end_date => (Date.strptime( @term.end_date , '%m/%d/%Y') + 2).strftime("%m/%d/%Y")     #add 2 days
end

When /^I add events to the Academic Calendar$/ do
  #@event = make CalendarEvent, :event_year => @calendar.year
  #@calendar.edit :@events => [ @event ]
  @calendar.search
  on CalendarSearch do |page|
    page.edit @calendar.name
  end
  on EditAcademicCalendar do |page|
    page.event_toggle
    wait_until { page.event_type.enabled? }
    page.event_type.select "Commencement - Seattle Campus"
    page.event_start_date.set "04/15/#{next_year[:year]}"
    page.event_end_date.set "05/15/#{next_year[:year] + 1}"
    page.event_start_time.set "07:30"
    page.event_end_time.set "09:00"
    page.event_start_ampm.select "pm"
    page.event_end_ampm.select "pm"
    page.all_day.clear
    page.date_range.set
    page.add_event.click
    page.save
  end
end

Then /^the events are listed when I view the Academic Calendar$/ do
  @calendar.search

  on CalendarSearch do |page|
    page.view @calendar.name
  end

  on ViewAcademicCalendar do |page|
    page.go_to_calendar_tab
    page.open_event_section
    if event_row = target_event_row("Commencement - Seattle Campus")
      return check_start_end_date(event_row, "04/15/#{next_year[:year]}", "05/15/#{next_year[:year] + 1}")
    else
      raise 'Created event not found in event table'
    end
    #  page.term_name(@term.term_type).should == @term.term_name
    #on EditAcademicCalendar do |page|
    #  page.academic_calendar_name.value.should == @calendar.name
    #  page.calendar_start_date.value.should == @calendar.start_date
    #  page.calendar_end_date.value.should == @calendar.end_date
    #end
  end
end

When /^I delete the term$/ do
  @calendar.delete_term(@term)
end

When /^the term is not listed when I view the Academic Calendar$/ do
  @calendar.view
  on ViewAcademicTerms do |page|
    page.term_index_by_term_type(@term.term_type).should == -1 #means not present
  end
end

Then /^the term is listed in official status when I view the Academic Calendar$/ do
  @calendar.view
  on ViewAcademicTerms do |page|
    page.go_to_terms_tab
    page.term_status(@term.term_type).should == "OFFICIAL"
  end
end

Then /^I add a new term to the Academic Calendar with an instructional key date$/ do
  step "I add a new term to the Academic Calendar"
  step "I add an instructional Key Date"
end

Then /^I add an instructional Key Date$/ do
  @term.edit

  @keydategroup = create KeyDateGroup, :key_date_group_type=> "Instructional", :term_type=> @term.term_type
  @keydate = create KeyDate, :parent_key_date_group => @keydategroup, :key_date_type => "First Day of Classes", :start_date => "09/12/#{@term.term_year}", :all_day => true

end

Then /^I edit an instructional Key Date$/ do
  @term.edit

  @keydategroup = make KeyDateGroup, :key_date_group_type=> "Instructional", :term_type=> @term.term_type
  @keydate = make KeyDate, :parent_key_date_group => @keydategroup, :key_date_type => "First Day of Classes"
  @keydate.edit :start_date => "09/14/#{@term.term_year}"
end

Then /^I delete an instructional Key Date Group$/ do
  @term = make AcademicTerm, :term_year => @calendar.year, :term_name => "Continuing Education Term 1", :term_type => "Continuing Education Term 1"
  @term.edit

  @keydategroup = make KeyDateGroup, :key_date_group_type=> "Instructional", :term_type=> @term.term_type
  @keydategroup.delete
end


Then /^I delete an instructional Key Date$/ do
  @term = make AcademicTerm, :term_year => @calendar.year, :term_name => "Continuing Education Term 1", :term_type => "Continuing Education Term 1"
  @term.edit

  @keydategroup = make KeyDateGroup, :key_date_group_type=> "Instructional", :term_type=> @term.term_type
  @keydate = make KeyDate, :parent_key_date_group => @keydategroup, :key_date_type => "First Day of Classes"
  @keydate.delete
end

Then /^the Key Date is listed with the academic term information$/ do
  @calendar.view
  on ViewAcademicTerms do |page|
    page.go_to_terms_tab
    page.open_term_section(@term.term_type)
    page.key_date_start(@term.term_type, "Instructional", @keydate.key_date_type ).should == @keydate.start_date
  end
end

Then /^the updated Key Date is listed with the academic term information$/ do
  @calendar.view
  on ViewAcademicTerms do |page|
    page.go_to_terms_tab
    page.open_term_section(@term.term_type)
    page.key_date_start(@term.term_type, "Instructional", @keydate.key_date_type ).should == @keydate.start_date
  end
end

Then /^the Key Date is not listed with the academic term information$/ do
  @calendar.view
  on ViewAcademicTerms do |page|
    page.go_to_terms_tab
    page.open_term_section(@term.term_type)
    page.target_key_date_row(@term.term_type, "Instructional", @keydate.key_date_type).exists?.should == false
  end
end

Then /^the Key Date Group is not listed with the academic term information$/ do
  @calendar.view
  on ViewAcademicTerms do |page|
    page.go_to_terms_tab
    page.open_term_section(@term.term_type)
    page.key_date_group_div(@term.term_type, "Instructional").nil?.should == true
  end
end

Then /^the Key Dates are copied without date values$/ do
  @term = make AcademicTerm, :term_year => @calendar.year, :term_name => "Continuing Education Term 1", :term_type => "Continuing Education Term 1"
  @term.edit

  @keydategroup = make KeyDateGroup, :key_date_group_type=> "Instructional", :term_type=> @term.term_type
  @keydate = make KeyDate, :parent_key_date_group => @keydategroup, :key_date_type => "First Day of Classes"

  @keydategroup2 = make KeyDateGroup, :key_date_group_type=> "Registration", :term_type=> @term.term_type
  @keydate2 = make KeyDate, :parent_key_date_group => @keydategroup2, :key_date_type => "Drop Date"

  on EditAcademicTerms do |page|
    page.go_to_terms_tab
    page.key_date_exists?(@term.term_type, "Instructional", "First Day of Classes").should == true

    row = page.key_date_target_row(@term.term_type, "Instructional", "First Day of Classes")
    page.key_date_start_date(row).should == ""
    page.key_date_start_time(row).should == ""
    page.key_date_end_date(row).should == ""
    page.key_date_end_time(row).should == ""
    #page.key_date_is_all_day(row).should == false
    #page.key_date_is_range(row).should == false

    page.key_date_exists?(@term.term_type, "Registration", "Drop Date").should == true

    row = page.key_date_target_row(@term.term_type, "Registration", "Drop Date")
    page.key_date_start_date(row).should == ""
    page.key_date_start_time(row).should == ""
    page.key_date_end_date(row).should == ""
    page.key_date_end_time(row).should == ""
    #page.key_date_is_all_day(row).should == false
    #page.key_date_is_range(row).should == false

  end
end

Then /^the instructional days calculation is correct$/ do
  @calendar.view
  on ViewAcademicTerms do |page|
    page.go_to_terms_tab
    page.open_term_section(@term.term_type)
    page.term_instructional_days(@term.term_type).to_i.should == @term.expected_instructional_days.to_i
  end
end

When /^I add a Holiday Calendar with holidays in the term$/ do
  holiday_list =  Array.new(1){make Holiday, :type=>"Columbus Day", :start_date=>"09/05/#{@term.term_year}", :all_day=>true, :date_range=>false, :instructional=>false}
  @holiday_calendar = create HolidayCalendar, :start_date => @calendar.start_date,
                             :end_date => @calendar.end_date,
                             :holiday_types => holiday_list
  @holiday_calendar.make_official

  @calendar.add_holiday_calendar(@holiday_calendar)
  @term.expected_instructional_days -= 1 # 1 holiday added

end

When /^I add a Holiday Calendar to the Academic Calendar$/ do
  pending
end
