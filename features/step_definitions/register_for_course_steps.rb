When /^I add an? (\w+) course offering to my registration cart$/ do |subj|

  # Get original counts before adding course to cart
  if subj=="WMST" || subj=="BSCI2"
    visit RegistrationCart do |page|
      sleep 1
      @orig_cart_course_count = page.credit_count_title.text.downcase.match('(\d*) course')[1].to_i
      @orig_cart_credit_count = page.credit_count_title.text.downcase.match('\((.*) credit')[1].to_f
    end
  end

  # Assign values for course attributes
  case subj
    when "BSCI1" then
      course_code = "BSCI106"
      reg_group_code = "1001"
      term_code = "201201"
      term_descr = "Spring 2012"
      credit_option = "4.0"
      course_has_options = true
    when "BSCI2" then
      course_code = "BSCI105"
      reg_group_code = "1004"
      term_code = "201201"
      term_descr = "Spring 2012"
      credit_option = "4.0"
      course_has_options = true
    when "BSCI3" then
      course_code = "BSCI120"
      reg_group_code = "1001"
      term_code = "201208"
      term_descr = "Fall 2012"
      credit_option = "4.0"
      course_has_options = true
    when "CHEM" then
      course_code = "CHEM241"
      reg_group_code = "1001"
      term_code = "201201"
      term_descr = "Spring 2012"
      credit_option = "3.0"
      course_has_options = true
    when "CHEM3" then
      course_code = "CHEM399A"
      reg_group_code = "1001"
      term_code = "201208"
      term_descr = "Fall 2012"
      credit_option = "3.0"
      course_has_options = true
    when "ENGL1" then
      course_code = "ENGL211"
      reg_group_code = "1001"
      term_code = "201201"
      term_descr = "Spring 2012"
      credit_option = "3.0"
      course_has_options = true
    when "ENGL2" then
      course_code = "ENGL101"
      reg_group_code = "1001"
      term_code = "201208"
      term_descr = "Fall 2012"
      credit_option = "3.0"
      course_has_options = false
    when "ENGL3" then
      course_code = "ENGL101"
      reg_group_code = "1009"
      term_code = "201208"
      term_descr = "Fall 2012"
      credit_option = "3.0"
      course_has_options = false
    when "ENGL4" then
      course_code = "ENGL101"
      reg_group_code = "1003"
      term_code = "201208"
      term_descr = "Fall 2012"
      credit_option = "3.0"
      course_has_options = false
    when "ENGL5" then
      course_code = "ENGL211"
      reg_group_code = "1001"
      term_code = "201208"
      term_descr = "Fall 2012"
      credit_option = "3.0"
      course_has_options = true
    when "HIST" then
      course_code = "HIST111"
      reg_group_code = "1001"
      term_code = "201201"
      term_descr = "Spring 2012"
      credit_option = "3.0"
      course_has_options = true
    when "HIST2" then
      course_code = "HIST110"
      reg_group_code = "1001"
      term_code = "201208"
      term_descr = "Fall 2012"
      credit_option = "3.0"
      course_has_options = true
    when "HIST26" then
      term_code = "201208"
      course_code = "HIST266"
      reg_group_code = "1001"
      term_descr = "Fall 2012"
      credit_option = "3.0"
      course_has_options = true
    when "HIST3" then
      course_code = "HIST133"
      reg_group_code = "1001"
      term_code = "201208"
      term_descr = "Fall 2012"
      credit_option = "3.0"
      course_has_options = true
    when "PHYS" then
      course_code = "PHYS102"
      reg_group_code = "1001"
      term_code = "201201"
      term_descr = "Spring 2012"
      credit_option = "3.0"
      course_has_options = true
    when "PHYS2" then
      course_code = "PHYS121"
      reg_group_code = "1048"
      term_code = "201208"
      term_descr = "Fall 2012"
      credit_option = "4.0"
      course_has_options = true
    when "PHYS3" then
      course_code = "PHYS161"
      reg_group_code = "1001"
      term_code = "201208"
      term_descr = "Fall 2012"
      credit_option = "3.0"
      course_has_options = true
    when "WMST" then
      course_code = "WMST360"
      reg_group_code = "1001"
      term_code = "201201"
      term_descr = "Spring 2012"
      credit_option = "3.0"
      course_has_options = true
    else
      reg_group_code = "1001"
      term_code = "201201"
      term_descr = "Spring 2012"
      credit_option = "3.0"
      course_has_options = true
  end

  course_options = (make CourseOptions, :credit_option => credit_option)
  @reg_request = make RegistrationRequest, :student_id=>"student",
                      :term_code=> term_code,
                      :term_descr=> term_descr,
                      :course_code=>course_code,
                      :reg_group_code=>reg_group_code,
                      :course_options => course_options,
                      :course_has_options=> course_has_options
  @reg_request.create
end

When /^I add a course offering having multiple credit options to my registration cart$/ do
  @reg_request = make RegistrationRequest, :student_id=>"student",
                                           :term_code=>"201201",
                                           :term_descr=>"Spring 2012",
                                           :course_code=>"WMST498B",
                                           :reg_group_code=>"1001"
  @reg_request.create
end

When /^I add a course to my registration cart and specify course options$/ do
  course_options = (make CourseOptions, :credit_option => "2.5", :grading_option => "Pass/Fail")
  @reg_request = create RegistrationRequest, :student_id => "student", :term_code => "201201",
                        :term_descr=>"Spring 2012",
                        :course_code=>"PHYS399",
                        :reg_group_code=>"1001", :course_options => course_options, :modify_course_options => true
  # above will include entering course_code, reg_group_code and clicking Add to Cart, then changing the 2 options, and clicking Save
end

When /^I remove the course from my registration cart$/ do
  @reg_request.remove_from_cart
end

And /^I edit the course in my registration cart$/ do
  @reg_request.course_options.credit_option = "1.5"
  @reg_request.course_options.grading_option = "Pass/Fail"
  @reg_request.edit_course_options :credit_option => @reg_request.course_options.credit_option,
                                   :grading_option => @reg_request.course_options.grading_option,
                                   :context => "cart"
end

When /^I edit the course in my schedule$/ do
  @reg_request.edit_course_options :credit_option => "2.5",
                                   :grading_option => "Audit",
                                   :context => "schedule"
end

Then /^the course is (present|not present) in my cart$/  do |presence|
  on RegistrationCart do |page|
    if presence == "present"
      sleep 2
      page.course_title(@reg_request.course_code, @reg_request.reg_group_code).should_not be_nil
    else
      sleep 1
      course_code_text = "#{@reg_request.course_code}(#{@reg_request.reg_group_code})"
      page.user_message_div.wait_until_present
      #Escape because string has () in it
      page.user_message.should match /Removed(\s+)#{Regexp.escape(course_code_text)}/i
      page.course_code(@reg_request.course_code, @reg_request.reg_group_code).exists?.should be_false
    end
  end
end

Then /^the course is present in my cart, with the updated options$/  do
  on RegistrationCart do |page|
    page.course_info_div(@reg_request.course_code,@reg_request.reg_group_code).wait_until_present
    unless @reg_request.course_options.grading_option == "Letter"
      page.grading_option_badge(@reg_request.course_code, @reg_request.reg_group_code).wait_until_present
      page.grading_option(@reg_request.course_code, @reg_request.reg_group_code).should include "#{@reg_request.course_options.grading_option}"
    end
  end
end

And /^I (attempt to )?register for the courses?$/ do |attempt|
  @reg_request.register
  sleep 3
end

Then /^there is a message indicating successful registration$/ do
  on RegistrationCart do |page|
    page.wait_until { !page.registering_message.visible? } if page.registering_message.visible?
    sleep 1
    page.course_code_message(@reg_request.course_code,@reg_request.reg_group_code).text.should include "Success"
  end
end

And /^the registration process has finished$/ do
  on RegistrationCart do |page|
    page.wait_until { !page.registering_message.visible? } if page.registering_message.visible?
    sleep 1
  end
end

Then /^there is a message indicating the course was dropped$/ do
  on StudentSchedule do |page|
    page.user_message_div("schedule").wait_until_present
    page.wait_until { page.user_message("schedule") =~ /dropped successfully/i }
  end
end

When /^I remove the ?(BSCI2)? course from my schedule$/ do |phys|
  @reg_request.remove_course("schedule")
end

When /^I? ?remove the course from my schedule and cancel the drop$/ do
  @reg_request.remove_from_schedule_and_cancel
end

When /^I drop a course I am registered for that has a waitlist$/ do
  course_options = (make CourseOptions, :credit_option => "3.0")

  @reg_request = make RegistrationRequest, :student_id=>"B.EILEENB",
                      :term_code=> 201208,
                      :term_descr=> "Fall 2012",
                      :course_code=> "ENGL101",
                      :reg_group_code=> "1010",
                      :course_options => course_options,
                      :course_has_options=> false

  visit StudentSchedule
  @reg_request.remove_course("schedule")
  sleep 3
end

When /^I view my schedule$/ do
  on RegistrationCart do |page|
    page.menu
    page.schedule_link.wait_until_present
    page.schedule_link.click
  end
end

And /^the course is (present|not present) in my schedule$/ do |presence|
  sleep 1
  on StudentSchedule do |page|
    if presence == "present"
      page.course_code(@reg_request.course_code, @reg_request.reg_group_code).wait_until_present
      page.course_code(@reg_request.course_code, @reg_request.reg_group_code).text.should_not be_nil
    else
      page.course_code(@reg_request.course_code, @reg_request.reg_group_code).exists?.should be_false
    end
  end
end

And /^I? ?can view the details of my selection in the registration cart$/ do
  on RegistrationCart do |page|
    page.toggle_course_details(@reg_request.course_code, @reg_request.reg_group_code)
    page.wait_until { page.ao_type(@reg_request.course_code, @reg_request.reg_group_code,0) != "" }
    page.course_title(@reg_request.course_code, @reg_request.reg_group_code).should == "Organic Chemistry II"
    page.course_info(@reg_request.course_code, @reg_request.reg_group_code).should include "#{@reg_request.course_options.credit_option[0]} cr"
    unless @reg_request.course_options.grading_option == "Letter"
      page.grading_option_badge(@reg_request.course_code, @reg_request.reg_group_code).wait_until_present
      page.grading_option(@reg_request.course_code, @reg_request.reg_group_code).should include "#{@reg_request.course_options.grading_option}"
    end
    page.ao_type(@reg_request.course_code, @reg_request.reg_group_code,0).should include "Discussion"
    page.course_schedule(@reg_request.course_code, @reg_request.reg_group_code,0,0).should match /Tu 8:00-8:50am(\s+)CHM 0128/i
    page.ao_type(@reg_request.course_code, @reg_request.reg_group_code,1).should include "Lecture"
    page.course_schedule(@reg_request.course_code, @reg_request.reg_group_code,1,0).should match /MWF 8:00-8:50am(\s+)HJP 0226/i
  end
end

And /^I? ?can view the details of my selection in my schedule$/ do
  on StudentSchedule do |page|
    page.show_course_details(@reg_request.course_code, @reg_request.reg_group_code, "schedule")
    page.wait_until { page.ao_type(@reg_request.course_code, @reg_request.reg_group_code,0) != "" }
    page.course_info(@reg_request.course_code, @reg_request.reg_group_code).should include "#{@reg_request.course_options.credit_option[0]} cr"
    unless @reg_request.course_options.grading_option == "Letter"
      page.grading_option_badge(@reg_request.course_code, @reg_request.reg_group_code).wait_until_present
      page.grading_option(@reg_request.course_code, @reg_request.reg_group_code).should include "#{@reg_request.course_options.grading_option}"
    end
    page.ao_type(@reg_request.course_code, @reg_request.reg_group_code,0).should include "Lecture"
    page.course_schedule(@reg_request.course_code, @reg_request.reg_group_code,0,0).should match /TuTh 2:00-2:50pm(\s+)KEY 0106/i
    page.ao_type(@reg_request.course_code, @reg_request.reg_group_code,1).should include "Discussion"
    page.course_schedule(@reg_request.course_code, @reg_request.reg_group_code,1,0).should match /Th 11:00-11:50am(\s+)LEF 1222/
  end
end

Then /^I? ?undo the drop action$/ do
  on RegistrationCart do |page|
    @reg_request.undo_remove_from_cart
    sleep 3
  end
end

And /^I? ?view my registration cart$/ do
  visit RegistrationCart do |page|
    term_descr = "Spring 2012"
    page.menu_button.wait_until_present
    page.menu
    page.wait_until {page.term_select.include? term_descr }
    page.select_term term_descr
    page.menu
  end
end


Given /^I have registered for an? (\w+) course$/ do |subj|
  steps %{
    When I add an #{subj} course offering to my registration cart
    And I register for the course
    And I view my schedule
    Then the course is present in my schedule
  }
end

Given /^I have registered for a course having multiple credit options$/ do
  @reg_request = make RegistrationRequest, :student_id=>"student",
                      :term_code=>"201208",
                      :term_descr=>"Fall 2012",
                      :course_code=>"CHEM399B",
                      :reg_group_code=>"1001"
  @reg_request.create

  steps %{
    Then the course is present in my cart
    And I register for the course
    And I view my schedule
    Then the course is present in my schedule
  }
end

Then /^the course is present in my schedule, with the updated options$/ do
  on StudentSchedule do |page|
    page.course_info_div(@reg_request.course_code,@reg_request.reg_group_code).wait_until_present
    sleep 1
    page.course_info(@reg_request.course_code, @reg_request.reg_group_code).should include "#{@reg_request.course_options.credit_option} cr"
    unless @reg_request.course_options.grading_option == "Letter"
      page.grading_option_badge(@reg_request.course_code, @reg_request.reg_group_code).wait_until_present
      page.grading_option(@reg_request.course_code, @reg_request.reg_group_code).should include "#{@reg_request.course_options.grading_option}"
    end
  end
end

When /^I register as (\w+) for a course offering with a seat capacity of one$/ do |user|
  @reg_request = make RegistrationRequest, :student_id=>user,
                      :term_code=>"201208",
                      :term_descr=>"Fall 2012",
                      :course_code=>"ENGL101",
                      :reg_group_code=>"1009",
                      :course_has_options=>false
  @reg_request.create
  @reg_request.register
  sleep 3
end

Then /^there is a message indicating that the course is full$/  do
  on RegistrationCart do |page|
    page_status = page.result_status(@reg_request.course_code,@reg_request.reg_group_code).downcase
    page_status.should include "no seats available"
  end
end

Then /^I can view the number of courses and credits I am registered for in my registration cart$/ do
  on RegistrationCart do |page|
    sleep 2
    @updated_cart_course_count = page.credit_count_title.text.downcase.match('(\d*) course')[1].to_i
    @updated_cart_course_count.should == (@orig_cart_course_count + 1)
    @updated_cart_credit_count = page.credit_count_title.text.downcase.match('\((.*) credit')[1].to_f
    @updated_cart_credit_count.should == (@orig_cart_credit_count + @reg_request.course_options.credit_option.to_f)
  end
end

Then /^the number of credits I am registered for is correctly updated in my registration cart$/ do
  on RegistrationCart do |page|
    page.wait_until { page.course_code_message(@reg_request.course_code, @reg_request.reg_group_code).text =~ /success/i }
    sleep 0.5
    @cart_reg_credit_count = page.credit_count_header.text.downcase.match('(.*) credit')[1].to_f
    page.credit_count_header.text.downcase.match('(.*) credit')[1].to_f.should == @cart_reg_credit_count
  end
end

Then /^the number of credits I am registered for is correctly updated in my schedule ?(after the drop)?$/ do  |drop|
  on StudentSchedule do |page|
    if drop == "after the drop"
      page.user_message_div("schedule").wait_until_present
      page.wait_until { page.user_message("schedule") =~ /drop processing/i }
      page.wait_until { page.user_message("schedule") !~ /drop processing/i }
      credits_to_drop = @reg_request.course_options.credit_option
      @cart_reg_credit_count -= credits_to_drop.to_f
    end
    sleep 1
    page.reg_credit_count.downcase.match("(.*) credits")[1].to_f.should == @cart_reg_credit_count
  end
end

Then /^I log out from student registration$/ do
  on RegisterForCourseBase do |page|
    page.menu
    page.logout_button.wait_until_present
    page.logout
  end
end

Then /^I log out from student registration large format$/ do
  on LargeFormatRegisterForCourseBase do |page|
    page.user_menu
    page.logout_link.wait_until_present
    page.logout
  end
  on Login do
    #just wait for page to come up
  end
end

Then /^the number of credits I am registered for and waitlisted for are correctly updated in my schedule$/ do
  on StudentSchedule do |page|
    page.reg_credit_count.downcase.match('(.*) credits')[1].to_f.should == 3
    #page.
  end
end

Given /^I log in to student registration as ([\w\.]+)$/  do |user|
  on RestLoginPage do |page|
    sleep 1
    page.login_as user
  end
  puts "I am logged in to student registration as #{user}"
end

And /^I elect to keep the failed course in my cart$/ do
  on RegistrationCart do |page|
    page.keep_in_cart_button(@reg_request.course_code,@reg_request.reg_group_code).wait_until_present
    page.keep_in_cart(@reg_request.course_code,@reg_request.reg_group_code)
  end
end

Given /^my schedule and cart are empty$/ do
  on RegistrationRestCallPage do |page|
    page.clearSchedule @term_code
  end
  on RegistrationCartRestCallPage do |page|
    page.clearCart @term_code
  end
end


When /^I attempt to register for a course that I have already taken the maximum allowable number of times$/ do
  @reg_request = make RegistrationRequest, :student_id=>"R.JOANL",
                      :term_code=> "201208",
                      :term_descr=> "Fall 2012",
                      :course_code=>"PHYS260",
                      :reg_group_code=>"1001",
                      :course_options => (make CourseOptions, :grading_option => "Letter"),
                      :course_has_options=> true
  @reg_request.create
  @reg_request.register
end

And /^there is a message indicating that I have taken the course the maximum allowable number of times$/ do
  on RegistrationCart do |page|
    page.course_code(@reg_request.course_code,@reg_request.reg_group_code).wait_until_present
    page_status = page.result_status(@reg_request.course_code,@reg_request.reg_group_code)
    page_status.should =~ /#{@reg_request.course_code} has already been taken (\w+)\.(\s*)Courses cannot be attempted more than/i
  end
end

Then /^there is a message indicating a course with grade I cannot be retaken$/ do
  on RegistrationCart do |page|
    page.course_code(@reg_request.course_code,@reg_request.reg_group_code).wait_until_present
    page_status = page.result_status(@reg_request.course_code, @reg_request.reg_group_code)
    page_status.should =~ /#{@reg_request.course_code}/i
    page_status.should =~ /Cannot repeat a course with a mark of 'I'/i
  end
end

Then /^there is a message indicating this is the last allowable repeat$/ do
  on RegistrationCart do |page|
    page.course_code(@reg_request.course_code,@reg_request.reg_group_code).wait_until_present
    page_status = page.result_status(@reg_request.course_code, @reg_request.reg_group_code)
    page_status.should =~ /This will be your second attempt of #{@reg_request.course_code}/i
    page_status.should =~ /This course cannot be attempted more than twice/i
  end
end

Then /^I attempt to register for a course in which I have received a mark of I$/ do
  @reg_request = make RegistrationRequest, :student_id=>"R.JODYB",
                      :term_code=> "201208",
                      :term_descr=> "Fall 2012",
                      :course_code=>"HIST352",
                      :reg_group_code=>"1001",
                      :course_options => (make CourseOptions, :grading_option => "Letter"),
                      :course_has_options=> true
  @reg_request.create
  @reg_request.register
end

When /^I register for a course for the second time$/ do
  @reg_request = make RegistrationRequest, :student_id=>"R.JOER",
                      :term_code=> "201108",
                      :term_descr=> "Fall 2011",
                      :course_code=>"BSCI105",
                      :reg_group_code=>"1001",
                      :course_options => (make CourseOptions, :grading_option => "Letter"),
                      :course_has_options=> true
  @reg_request.create
  @reg_request.register

end

