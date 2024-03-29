When /^I change the final exam period start date to be before the term start date and save$/ do
  @calendar = create AcademicCalendar

  term = make AcademicTermObject, :parent_calendar => @calendar,
              :term => "Fall"

  term.exam_period = make ExamPeriodObject, :parent_term => term
  @calendar.add_term term

  @calendar.terms[0].exam_period.edit :start_date => "08/15/#{@calendar.year}", :use_date_picker => true
end

When /^I change the final exam period end date to be after the term end date and save$/ do
  @calendar = create AcademicCalendar

  term = make AcademicTermObject, :parent_calendar => @calendar,
              :term => "Fall"

  term.exam_period = make ExamPeriodObject, :parent_term => term
  @calendar.add_term term

  @calendar.terms[0].exam_period.edit :end_date => "10/15/#{@calendar.year}"
end

When /^I add a final exam period to the new academic calender and save$/ do
  @calendar = create AcademicCalendar

  term = make AcademicTermObject, :parent_calendar => @calendar, :start_date=>"08/20/#{@calendar.year}",
               :end_date=>"12/10/#{@calendar.year}", :term => "Fall"
  @calendar.add_term term

  exam_period = make ExamPeriodObject, :parent_term => term, :start_date=>"12/11/#{@calendar.year}",
                     :end_date=>"12/20/#{@calendar.year}"
  @calendar.terms[0].add_exam_period exam_period
  @calendar.terms[0].save
end

When /^I copy a newly created academic calendar that has a defined final exam period$/ do
  @source_calendar = create AcademicCalendar

  term = make AcademicTermObject, :parent_calendar => @source_calendar, :start_date=>"09/20/#{@source_calendar.year}",
               :end_date=>"12/10/#{@source_calendar.year}"
  @source_calendar.add_term term

  exam_period = make ExamPeriodObject, :parent_term => term, :start_date=>"12/11/#{@source_calendar.year}",
                     :end_date=>"12/20/#{@source_calendar.year}"
  @source_calendar.terms[0].add_exam_period exam_period
  @source_calendar.terms[0].save

  @calendar = make AcademicCalendar, :year => "#{@source_calendar.year.to_i + 1}"
  @calendar.copy_from @source_calendar.name
end

When /^I copy an existing academic calendar that has a defined final exam period$/ do
  @source_calendar = make AcademicCalendar, :year => "2012", :name => "2012-2013 Academic Calendar"

  term = make AcademicTermObject, :parent_calendar => @source_calendar
  @source_calendar.terms << term

  @calendar = make AcademicCalendar

  @calendar.copy_from @source_calendar.name
end

Given /^that the catalog version of the course is set to have a standard final exam$/ do
  @course_offering = make CourseOffering, :term => "201301", :course => "PHYS603", :defer_save => true
end

Given /^that the catalog version of the course is set to not have a standard final exam$/ do
  @course_offering = make CourseOffering, :term => "201208", :course => "ENGL101", :defer_save => true,
                          :final_exam_type => "ALTERNATE"
end

Given /^that the catalog version of the course is set to have No final exam$/ do
  @course_offering = make CourseOffering, :term => "201301", :course => "PHYS603", :defer_save => true,
                          :final_exam_type => "NONE"
end

When /^I create a Course Offering from catalog in a term with a final exam period$/ do
  @course_offering.create
end

When /^I create a Course Offering from catalog with an alternate final assessment option$/ do
  @course_offering = create CourseOffering, :term => "201208", :course => "ENGL101", :final_exam_type => "ALTERNATE"
end

When /^I create a Course Offering from an existing Course Offering with an alternate final assessment option$/ do
  @course_offering = (make CourseOffering, :term => "201201", :course => "ENGL101S").create_from_existing :target_term => '201201'
end

When /^I edit the Course Offering to have a Standard Final Exam$/ do
  @course_offering.edit :final_exam_type => "Standard Final Exam"
end

And /^I select a Final Exam Driver option from the drop-down$/ do
  @course_offering.edit :final_exam_driver => "Final Exam Per Course Offering"
end

When /^I return to the Edit Co page for the course after updating the change$/ do
  on(ManageCourseOfferings).edit_course_offering
end

When /^I create a Course Offering from an existing Course Offering with a standard final exam option$/ do
  @course_offering = (make CourseOffering, :term => "201208", :course => "CHEM277").copy

  @activity_offering = make ActivityOfferingObject, :code => "A", :parent_cluster => @course_offering.default_cluster
  @activity_offering.edit :send_to_scheduler => true

  @course_offering_copy = @course_offering.create_from_existing :target_term=> @course_offering.term
  on(ManageCourseOfferings).edit_course_offering
end

When /^I create a course offering for a subject with a standard final exam in my admin org$/ do
  @course_offering = make CourseOffering, :term=> "201301", :course => "ENGL304"
  @course_offering.start_create_by_search
end

When /^I edit a course offering with a standard final exm in my admin org$/ do
  @course_offering = make CourseOffering, :term=> "201301", :course=>"ENGL304"
  @course_offering.manage
  on(ManageCourseOfferings).edit_course_offering
end

When /^I create an Academic Calendar and add an official term$/ do
  @calendar = create AcademicCalendar

  term = make AcademicTermObject, :parent_calendar => @calendar
  @calendar.add_term term

  @calendar.terms[0].make_official
  @term_code = @calendar.terms[0].term_code
  @manage_soc = make ManageSoc, :term_code => @term_code
  @manage_soc.set_up_soc
end

When /^I create an Academic Calendar and add an official term with no exam period$/ do
  @calendar = create AcademicCalendar

  term = make AcademicTermObject, :parent_calendar => @calendar

  @calendar.add_term term

  @calendar.terms[0].make_official
  @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
  @manage_soc.set_up_soc
end

When /^I have multiple Course Offerings each with a different Exam Offering in the source term$/ do
  @co_list = []

  @co_list << (create CourseOffering, :term => @calendar.terms[0].term_code, :course => "PHYS603",
                      :final_exam_type => "NONE")
  @co_list << (create CourseOffering, :term => @calendar.terms[0].term_code, :course => "PHYS603",
                      :final_exam_type => "ALTERNATE")
  @co_list << (create CourseOffering, :term => @calendar.terms[0].term_code, :course => "PHYS603",
                      :final_exam_driver => "Final Exam Per Activity Offering")
  co = make CourseOffering, :term => @calendar.terms[0].term_code, :course => "PHYS603", :use_final_exam_matrix => false
  co.delivery_format_list[0].format = "Lecture"
  co.delivery_format_list[0].grade_format = "Course Offering"
  co.delivery_format_list[0].final_exam_activity = "Lecture"
  @co_list << co.create
end

And /^I rollover the source term to a new academic term with an exam period$/ do
  @calendar_target = create AcademicCalendar, :year => @calendar.year.to_i + 1

  term_target = make AcademicTermObject, :parent_calendar => @calendar_target

  @calendar_target.add_term term_target

  exam_period = make ExamPeriodObject, :parent_term => term_target,
                     :start_date=>"12/11/#{@calendar.year}",
                     :end_date=>"12/20/#{@calendar.year}"
  @calendar_target.terms[0].add_exam_period exam_period

  @calendar_target.terms[0].save
  @calendar_target.terms[0].make_official

  @manage_soc = make ManageSoc, :term_code => @calendar_target.terms[0].term_code

  @rollover = make Rollover, :target_term => @calendar_target.terms[0].term_code ,
                   :source_term => @calendar.terms[0].term_code,
                   :exp_success => false
  @rollover.perform_rollover
  @rollover.wait_for_rollover_to_complete
end

When /^I(?: can)? rollover the term to a new academic term that has no exam period$/ do
  @calendar_target = create AcademicCalendar, :year => @calendar.year.to_i + 1

  term_target = make AcademicTermObject, :parent_calendar => @calendar_target
  @calendar_target.add_term term_target

  @calendar_target.terms[0].make_official

  @rollover = make Rollover, :target_term => @calendar_target.terms[0].term_code,
                   :source_term => @calendar.terms[0].term_code
  @rollover.perform_rollover
  @rollover.wait_for_rollover_to_complete
  @rollover.release_to_depts
end

When /^I view the Exam Offerings for a CO created from an existing CO with a standard final exam driven by Course Offering$/ do
  @original_co = engl304_published_eo_create_term

  @course_offering = @original_co.copy
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Course Offering"

  @activity_offering = make ActivityOfferingObject, :code => "A", :parent_cluster => @course_offering.default_cluster
  @activity_offering.edit :send_to_scheduler => true

  @create_co = @course_offering.create_from_existing :target_term=> @course_offering.term

  on(ManageCourseOfferings).view_exam_offerings
end

Given /^there is an exsiting CO with a Standard Final Exam option$/ do
  @original_co = engl301_published_eo_create_term

  @course_offering = @original_co.copy
  @activity_offering = make ActivityOfferingObject, :code => "A", :parent_cluster => @course_offering.default_cluster
  @activity_offering.edit :send_to_scheduler => true
end

Given /^that Activity Offerings exist for the selected Course Offering$/ do
  @original_co = engl304_published_eo_create_term

  @course_offering = @original_co.copy
  #setup existing format
  @course_offering.delivery_format_list[0].format = "Lecture/Discussion"
  @activity_offering = make ActivityOfferingObject, :code => "A", :parent_cluster => @course_offering.default_cluster
  @activity_offering.edit :send_to_scheduler => true
end

When /^I create a Course Offering from an existing CO with a Standard Final Exam option$/ do
  @create_co = @course_offering.create_from_existing :target_term=> @course_offering.term
end

When /^I select Final Exam Per Course Offering as the Final Exam Driver and Update the Course Offering$/ do
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Course Offering"
end

Then /^I should be able to select the View Exam Offerings link on the Manage CO page$/ do
  on ManageCourseOfferings do |page|
    page.view_exam_offerings_link.present?.should == true
    page.view_exam_offerings
  end
end

Then /^see Exam Offerings for each Activity Offering of the Course with a status of ([^"]*)$/ do |exp_state|
  on ViewExamOfferings do |page|
    page.table_header_text.should match /for Activity Offering/
    array = page.ao_code_list
    if array != nil
      array.each do |code|
        page.ao_eo_status(code).should match /#{exp_state}/
      end
      no_of_eos = array.length
    end
    array = page.ao_code_list("CL Leftovers")
    if array != nil
      array.each do |code|
        page.ao_eo_status(code, "CL Leftovers").should match /#{exp_state}/
      end
      no_of_eos = array.length
    end
    no_of_eos.should == 1
  end
end

Then /^see one Exam Offering for the Course Offering with a status of ([^"]*)$/ do |exp_state|
  on ViewExamOfferings do |page|
    page.table_header_text.should match /for Course Offering/
    page.co_eo_status.should match /#{exp_state}/
    page.co_eo_count.should == "1"
  end
end

When /^I view the Exam Offerings for a CO created from an existing CO with a standard final exam driven by Activity Offering$/ do
  @original_co = engl305_published_eo_create_term

  @course_offering = @original_co.create_from_existing :target_term=> @original_co.term
  on(ManageCourseOfferings).view_exam_offerings
end

When /^I select Final Exam Per Activity Offering as the Final Exam Driver and Update the Course Offering$/ do
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Activity Offering",
                                 :defer_save => true
  @course_offering.delivery_format_list[0].edit :final_exam_activity => "Lecture", :start_edit => false
end

When /^I view the Exam Offerings for a CO created from an existing CO with multiple AOs and a standard final exam driven by Activity Offering$/ do
  @original_co = make CourseOffering, :term => Rollover::PUBLISHED_EO_CREATE_TERM, :course => "HIST110"

  unless @original_co.exists?
    course_offering = make CourseOffering, :term=> @original_co.term,
                           :course => @original_co.course,
                           :suffix => ' ',
                           :final_exam_driver => "Final Exam Per Activity Offering"
    course_offering.delivery_format_list[0].format = "Lecture/Discussion"
    course_offering.delivery_format_list[0].grade_format = "Discussion"
    course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
    course_offering.create

    activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                               :format => "Lecture/Discussion", :activity_type => "Lecture"
    si_obj =  make SchedulingInformationObject, :days => "TH",
                   :start_time => "12:30", :start_time_ampm => "pm",
                   :end_time => "01:45", :end_time_ampm => "pm",
                   :facility => 'TWS', :room => '1106'
    activity_offering.add_req_sched_info :rsi_obj => si_obj, :defer_save => true
    activity_offering.edit :start_edit => false,
                           :send_to_scheduler => true

    activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                               :format => "Lecture/Discussion", :activity_type => "Discussion"
    si_obj =  make SchedulingInformationObject, :days => "W",
                   :start_time => "09:00", :start_time_ampm => "am",
                   :end_time => "09:50", :end_time_ampm => "am",
                   :facility => 'KEY', :room => '0117'
    activity_offering.add_req_sched_info :rsi_obj => si_obj
  end

  @course_offering = @original_co.create_from_existing :target_term=> @original_co.term
  on(ManageCourseOfferings).view_exam_offerings
end

When /^I view the Exam Offerings for a CO with two AOs and a standard final exam driven by Activity Offering$/ do
  @original_co = engl201_published_eo_create_term

  @course_offering = @original_co.copy
  on(ManageCourseOfferings).view_exam_offerings
end

Given /^that the CO has two existing AOs and a standard final exam driven by Activity Offering$/ do
  @original_co = engl201_published_eo_create_term
  @course_offering = @original_co.copy
end

When /^I add two new AOs to the CO and then create a copy of the CO$/ do
  @course_offering.initialize_with_actual_values
  @course_offering.activity_offering_cluster_list[0].ao_list[0].edit :send_to_scheduler => true
  @add_ao_one = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture Only")
  @add_ao_two = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture Only")

  @create_co = @course_offering.copy

  on(ManageCourseOfferings).view_exam_offerings
end

#TODO: confirm not used
When /^I view the Exam Offerings for a CO with two new AOs and a standard final exam driven by Activity Offering$/ do
  @course_offering = (make CourseOffering, :term => "201208", :course => "ENGL201").copy
  @activity_offering = @course_offering.activity_offering_cluster_list[0].ao_list[0]
  @activity_offering.edit :send_to_scheduler => true

  @add_ao_one = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture Only")
  @add_ao_two = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture Only")

  @create_co = @course_offering.create_from_existing :target_term=> @course_offering.term

  on(ManageCourseOfferings).view_exam_offerings
end

When /^I create a CO with two new AOs and then view the Exam Offerings where the CO has a standard final exam driven by Activity Offering$/ do
  @course_offering = (make CourseOffering, :term => "201208", :course => "ENGL201").copy
  @activity_offering = @course_offering.activity_offering_cluster_list[0].ao_list[0]
  #  make ActivityOfferingObject, :code => "A", :parent_course_offering => @course_offering
  @activity_offering.edit :send_to_scheduler => true

  @add_ao_one = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture Only")
  @add_ao_two = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture Only"), :navigate_to_page => false

  @create_co = @course_offering.create_from_existing :target_term=> @course_offering.term

  on(ManageCourseOfferings).view_exam_offerings
end

Given /^that the SOC state is prior to Published$/ do
  @term = Rollover::OPEN_EO_CREATE_TERM
end

When /^I view the Exam Offerings for a CO with a standard final exam driven by Course Offering$/ do
  @original_co = make CourseOffering, :term => @term, :course => "ENGL304"

  unless @original_co.exists?
    course_offering = make CourseOffering, :term=> @original_co.term,
                           :course => @original_co.course,
                           :suffix => ' ',
                           :final_exam_driver => "Final Exam Per Activity Offering"
    course_offering.delivery_format_list[0].format = "Lecture/Discussion"
    course_offering.delivery_format_list[0].grade_format = "Discussion"
    course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
    course_offering.create

    activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                               :format => "Lecture/Discussion", :activity_type => "Lecture"
    si_obj =  make SchedulingInformationObject, :days => "TH",
                   :start_time => "11:00", :start_time_ampm => "am",
                   :end_time => "11:50", :end_time_ampm => "am",
                   :facility => 'TWS', :room => '1100'
    activity_offering.add_req_sched_info :rsi_obj => si_obj

    #TODO: KSENROLL-13157 problems creating 2nd AO
    # activity_offering = create ActivityOfferingObject, :parent_course_offering => course_offering,
    #                            :format => "Lecture/Discussion", :activity_type => "Discussion"
    # si_obj =  make SchedulingInformationObject, :days => "W",
    #                :start_time => "09:00", :start_time_ampm => "am",
    #                :end_time => "09:50", :end_time_ampm => "am",
    #                :facility => 'KEY', :room => '0117'
    # activity_offering.add_req_sched_info :rsi_obj => si_obj
  end



  @course_offering = @original_co.copy
  @course_offering.delivery_format_list[0].format = "Lecture/Discussion"
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Course Offering"

  on(ManageCourseOfferings).view_exam_offerings
end

When /^I view the Exam Offerings for a CO in an Open SOC with a standard final exam driven by Activity Offering$/ do
  @original_co = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "ENGL304"

  unless @original_co.exists?
    course_offering = make CourseOffering, :term=> @original_co.term,
                           :course => @original_co.course,
                           :suffix => ' ',
                           :final_exam_driver => "Final Exam Per Activity Offering"
    course_offering.delivery_format_list[0].format = "Lecture/Discussion"
    course_offering.delivery_format_list[0].grade_format = "Discussion"
    course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
    course_offering.create

    activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                               :format => "Lecture/Discussion", :activity_type => "Lecture"
    si_obj =  make SchedulingInformationObject, :days => "TH",
                   :start_time => "11:00", :start_time_ampm => "am",
                   :end_time => "11:50", :end_time_ampm => "am",
                   :facility => 'TWS', :room => '1100'
    activity_offering.add_req_sched_info :rsi_obj => si_obj

    activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                               :format => "Lecture/Discussion", :activity_type => "Discussion"
    si_obj =  make SchedulingInformationObject, :days => "W",
                   :start_time => "09:00", :start_time_ampm => "am",
                   :end_time => "09:50", :end_time_ampm => "am",
                   :facility => 'KEY', :room => '0117'
    activity_offering.add_req_sched_info :rsi_obj => si_obj
  end

  @course_offering = @original_co.copy
  @course_offering.delivery_format_list[0].format = "Lecture/Discussion"

  @course_offering.edit :final_exam_type => "Standard Final Exam", :final_exam_driver => "Final Exam Per Activity Offering",
                        :defer_save => true

  @course_offering.delivery_format_list[0].edit :final_exam_activity => "Lecture", :start_edit => false

  on(ManageCourseOfferings).view_exam_offerings
end

When /^I view the Exam Offerings for a CO where the Course Offering Standard FE is changed to No Final Exam$/ do
  @original_co = engl305_published_eo_create_term

  @course_offering = @original_co.create_from_existing :target_term=> @original_co.term
  # @course_offering.delivery_format_list[0].format = "Lecture Only"
  @course_offering.edit :final_exam_type => "Standard Final Exam", :final_exam_driver => "Final Exam Per Course Offering"

  @course_offering.edit :final_exam_type => "No Final Exam or Assessment"

  on(ManageCourseOfferings).view_exam_offerings
end

Given /^that the CO is set to have exam offerings driven by CO$/ do

  @original_co = engl305_published_eo_create_term

  @course_offering = @original_co.copy
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Course Offering"
end

Given /^that the CO is set to have exam offerings driven by AO$/ do
  @original_co = engl305_published_eo_create_term

  @course_offering = @original_co.copy
  @course_offering.delivery_format_list[0].format = "Lecture/Discussion"
end

When /^I edit the CO to have an Alternate Final Exam$/ do
  @course_offering.initialize_with_actual_values

  @course_offering.edit :final_exam_type => "Alternate Final Assessment"
end

When /^I view the Exam Offerings for a CO where the Course Offering Standard FE setting is changed to No Final Exam$/ do
  @course_offering.edit :final_exam_type => "No Final Exam or Assessment"

  on(ManageCourseOfferings).view_exam_offerings
end

When /^I view the Exam Offerings for a CO where the Activity Offering Standard FE is changed to Alternate Final Exam$/ do
  @original_co = engl304_published_eo_create_term

  @course_offering = @original_co.copy
  @course_offering.delivery_format_list[0].format = "Lecture/Discussion"
  @course_offering.initialize_with_actual_values

  @course_offering.edit :final_exam_type => "Alternate Final Assessment"

  on(ManageCourseOfferings).view_exam_offerings
end

When /^I view the Exam Offerings for a CO where the Course Offering No FE is changed to Standard Final Exam$/ do
  @course_offering = (make CourseOffering, :term => "201208", :course => "ENGL304").copy
  @course_offering.edit :final_exam_type => "No Final Exam or Assessment"

  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver =>"Final Exam Per Course Offering"

  on(ManageCourseOfferings).view_exam_offerings
end

Given /^that the CO is set to have no exam offerings$/ do
  @original_co = engl304_published_eo_create_term

  @course_offering = @original_co.copy
  @course_offering.edit :final_exam_type => "No Final Exam or Assessment"
end

When /^I view the Exam Offerings for a CO where the Course Offering No Standard Final Exam or Assessment is changed to Standard Final Exam driven by Course Offering$/ do
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver =>"Final Exam Per Course Offering"

  on(ManageCourseOfferings).view_exam_offerings
end

When /^I view the Exam Offerings for a CO where the exam is changed to Standard Final Exam driven by Activity Offering$/ do
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Activity Offering",
                                 :defer_save => true
  @course_offering.delivery_format_list[0].edit :final_exam_activity => "Lecture", :start_edit => false

  on(ManageCourseOfferings).view_exam_offerings
end

When /^I view the Exam Offerings after changing the Final Exam Driver (?:to|back to) Course Offering$/ do
  @course_offering.manage
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Course Offering"

  on(ManageCourseOfferings).view_exam_offerings
end

When /^I view the Exam Offering after changing the Course Offering back to Standard FE and the Final Exam Driver to Course Offering$/ do
  @course_offering.manage
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Course Offering"

  on(ManageCourseOfferings).view_exam_offerings
end

When /^I view the Exam Offerings? after changing the Course Offering back to Standard FE and the Final Exam Driver to Activity Offering$/ do
  @course_offering.manage

  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Activity Offering",
                                 :defer_save => true
  @course_offering.delivery_format_list[0].edit :final_exam_activity => "Lecture", :start_edit => false

  on(ManageCourseOfferings).view_exam_offerings
end

When /^I view the Exam Offerings after changing the Final Exam Driver to Activity Offering$/ do
  @course_offering.manage

  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Activity Offering",
                                 :defer_save => true
  @course_offering.delivery_format_list[0].edit :final_exam_activity => "Lecture", :start_edit => false

  on(ManageCourseOfferings).view_exam_offerings
end

When /^I view the Exam Offerings after updating the Final Exam indicator to No final Exam$/ do
  @course_offering.manage
  @course_offering.edit :final_exam_type => "No Final Exam or Assessment"

  #on(ManageCourseOfferings).view_exam_offerings
end

When /^I view the Exam Offerings for a CO created from catalog with a standard final exam driven by Course Offering$/ do
  @course_offering = create CourseOffering, :term => Rollover::PUBLISHED_EO_CREATE_TERM, :course => "ENGL304"

  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Course Offering"

  on(ManageCourseOfferings).view_exam_offerings
end

When /^I add an Exam Period to the term$/ do
  exam_period = make ExamPeriodObject, :parent_term => @calendar.terms[0], :start_date=>"12/11/#{@calendar.year}",
                      :end_date=>"12/20/#{@calendar.year}"

  @calendar.terms[0].add_exam_period exam_period
  @calendar.terms[0].save
end

When /^I add an Exam Period to the new term$/ do
  exam_period = make ExamPeriodObject, :parent_term => @calendar.terms[0], :start_date=>"09/11/#{@calendar.year}",
                     :end_date=>"09/20/#{@calendar.year}"

  @calendar.terms[0].add_exam_period exam_period
  @calendar.terms[0].save
  sleep 2
end

When /^I deselect Exclude Saturday and Exclude Sunday for the Exam Period$/ do
  @calendar.terms[0].exam_period.edit :exclude_saturday => false, :exclude_sunday => false, :navigate_to_page => false
  @calendar.terms[0].save
end

When /^I create a Fall Term Exam Period with 2 fewer days than the number of Final Exam Matrix days$/ do
  term = make AcademicTermObject, :parent_calendar => @calendar, :start_date => "09/01/#{@calendar.year}",
                 :end_date=>"12/20/#{@calendar.year}"
  @calendar.add_term term

  exam_period = make ExamPeriodObject, :parent_term => @calendar.terms[0], :start_date => "12/01/#{@calendar.year}", :length_ex_weekend => 4
  @calendar.terms[0].add_exam_period exam_period

  @calendar.terms[0].save :exp_success => false
end

When /^there is more than one Activity Offering for the Course$/ do
  @original_co = engl301_published_eo_create_term

  @course_offering = @original_co.copy
end

When /^I cancel an Activity Offering for a CO with a standard final exam driven by Course Offering$/ do
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Course Offering"

  @activity_offering = make ActivityOfferingObject, :code => "A", :parent_cluster => @course_offering.default_cluster
  @activity_offering.cancel :navigate_to_page => false
end

When /^I cancel an Activity Offering for a CO with a standard final exam driven by Activity Offering$/ do
  @course_offering = (make CourseOffering, :term => "201208", :course => "ENGL301").copy
  @activity_offering = make ActivityOfferingObject, :code => "A", :parent_cluster => @course_offering.default_cluster
  @activity_offering.cancel :navigate_to_page => false
end

Given /^that the Lecture AO that drives the exam is not in a cancelled state$/ do
  @original_co = engl301_published_eo_create_term


  @course_offering = @original_co.copy
  delivery_format_list = []
  delivery_format_list[0] = make DeliveryFormatObject, :format => "Lecture/Discussion", :grade_format => "Course Offering", :final_exam_activity => "Lecture"

  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Activity Offering",
                                 :delivery_format_list => delivery_format_list
end

When /^I cancel a Discussion Activity Offering for a CO with a standard final exam driven by Activity Offering$/ do
  @activity_offering = make ActivityOfferingObject, :code => "A", :parent_cluster => @course_offering.default_cluster
  @activity_offering.cancel :navigate_to_page => false
end

When /^I cancel all Activity Offerings for a CO with a standard final exam driven by Course Offering$/ do
  @original_co = engl301_published_eo_create_term

  @course_offering = @original_co.copy
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Course Offering"

  on ManageCourseOfferings do |page|
    page.codes_list.each do |code|
      ao_cancel = make ActivityOfferingObject, :code => code, :parent_cluster => @course_offering.default_cluster
      ao_cancel.cancel :navigate_to_page => false
    end
  end
end

When /^I reinstate the one or more Activity offerings for the CO$/ do
  on ManageCourseOfferings do |page|
    page.cluster_select_all_aos
    page.reinstate_ao
  end
  on(ReinstateActivityOffering).reinstate_activity
end

When /^I cancel all Activity Offerings for a CO with a standard final exam driven by Activity Offering$/ do
  @original_co = engl301_published_eo_create_term

  @course_offering = @original_co.copy
  delivery_format_list = []
  delivery_format_list[0] = make DeliveryFormatObject, :format => "Lecture/Discussion", :grade_format => "Course Offering", :final_exam_activity => "Lecture"

  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Activity Offering",
                                 :delivery_format_list => delivery_format_list

  on ManageCourseOfferings do |page|
    page.codes_list.each do |code|
      ao_cancel = make ActivityOfferingObject, :code => code, :parent_cluster => @course_offering.default_cluster
      ao_cancel.cancel :navigate_to_page => false
    end
  end
end

When /^I? ?update all fields on the exam offering RSI$/ do
  @eo_rsi.edit :override_matrix => true,
               :do_navigation => false,
               :day => 'Day 5',
               :start_time => '4:00 PM',
               :end_time => '4:50 PM'
end

When /^I select override matrix and update the location fields on the exam offering RSI$/ do
  @eo_rsi.edit :override_matrix => true,
               :do_navigation => false,
               :facility => 'MTH',
               :room => '0303'
end

When /^I? ?update the available fields on the exam offering RSI$/ do
  @eo_rsi.edit :do_navigation => false,
               :day => 'Day 5',
               :start_time => '4:00 PM',
               :end_time => '4:50 PM',
               :facility => 'PHYS',
               :room => '4102'
end

When /^I select exam matrix override and update the available fields on the exam offering RSI$/ do
  @eo_rsi.edit :do_navigation => false,
               :override_matrix => true,
               :day => 'Day 5',
               :start_time => '4:00 PM',
               :end_time => '4:50 PM',
               :facility => 'PHYS',
               :room => '4102'
end

When /^I select matrix override and update the day and time fields on the exam offering RSI$/ do
  @eo_rsi.edit :do_navigation => false,
               :override_matrix => true,
               :day => 'Day 2',
               :start_time => '6:00 PM',
               :end_time => '7:00 PM'
end

When /^I subsequently remove matrix override from the CO driven exam offering RSI$/ do
  #first confirm edit was successful
  @course_offering.manage
  on(ManageCourseOfferings).view_exam_offerings
  on ViewExamOfferings do |page|
    page.co_target_row.exists?.should be_true
    page.co_eo_days.should match /#{@eo_rsi.day}/
    page.co_eo_st_time.should == @eo_rsi.start_time
    page.co_eo_end_time.should == @eo_rsi.end_time
    #page.co_eo_bldg.should == @eo_rsi.facility TODO: issue with short vs full facility name
    page.co_eo_room.should == @eo_rsi.room
  end
  @eo_rsi.remove_override_matrix :do_navigation => false
end

When /^I subsequently remove matrix override from the AO-driven exam offering RSI$/ do
  #first confirm edit was successful
  @course_offering.manage
  on(ManageCourseOfferings).view_exam_offerings
  ao_code = @eo_rsi.ao_code
  on ViewExamOfferings do |page|
    page.ao_eo_target_row(ao_code).exists?.should be_true
    page.ao_eo_days(ao_code).should match /#{@eo_rsi.day}/
    page.ao_eo_st_time(ao_code).should == @eo_rsi.start_time
    page.ao_eo_end_time(ao_code).should == @eo_rsi.end_time
    #page.ao_eo_bldg(ao_code).should == @eo_rsi.facility TODO: issue with short vs full facility name
    page.ao_eo_room(ao_code).should == @eo_rsi.room
  end
  @eo_rsi.remove_override_matrix :do_navigation => false
end

When /^I update the day and time fields on the exam offering RSI$/ do
  @eo_rsi.edit :do_navigation => false,
               :day => 'Day 2',
               :start_time => '6:00 PM',
               :end_time => '7:00 PM',
               :override_matrix => false
end

When /^I update the requested scheduling information for the related activity offering so there is no match on the exam matrix$/ do
  @course_offering.manage
  @activity_offering.edit :defer_save => true
  @activity_offering.requested_scheduling_information_list[0].edit :days => "SU",
                                                                   :start_time => "10:00", :start_time_ampm => "am",
                                                                   :end_time => "10:50", :end_time_ampm => "am"
  @activity_offering.save
end

When /^I update the scheduling information for the related activity offering and send to the scheduler$/ do
  @course_offering.manage
  @activity_offering.edit :defer_save => true
  @activity_offering.requested_scheduling_information_list[0].edit :days => "SU",
                                                                   :start_time => "10:00", :start_time_ampm => "am",
                                                                   :end_time => "10:50", :end_time_ampm => "am",
                                                                   :send_to_scheduler => true
  @activity_offering.save
end

When /^I select override matrix and delete the contents of the exam offering RSI facility and room number fields$/ do
  @eo_rsi.edit :do_navigation => false, :facility => '', :room => '', :override_matrix => true
end

When /^I leave exam offering RSI Day field blank$/ do
  @eo_rsi.edit :do_navigation => false, :day => '', :override_matrix => true, :exp_success=> false
end

When /^I enter a blank time in the exam offering RSI end time field$/ do
  @eo_rsi.edit :do_navigation => false, :end_time => '', :override_matrix => true, :exp_success=> false
end

When /^enter an invalid room code in the exam offering RSI room field$/ do
  @eo_rsi.edit :do_navigation => false, :room => '98989', :override_matrix => true, :exp_success=> false
end

When /^I enter an invalid facility code in the exam offering RSI facility field$/ do
  @eo_rsi.edit :do_navigation => false, :facility => 'NX2', :override_matrix => true, :exp_success=> false
end

When /^I enter an invalid time in the exam offering RSI start time field$/ do
  @eo_rsi.edit :do_navigation => false, :start_time => '13:00 AM', :override_matrix => true, :exp_success=> false
end

When /^the error displayed for AO-driven exam offerings RSI day field is required$/ do
  on ViewExamOfferings do |page|
    row = page.ao_eo_target_row(@activity_offering.code)
    page.rsi_day(row).click
    sleep 1
    popup_text = page.div(id: /jquerybubblepopup/, data_for: "#{page.rsi_day(row).id}").table.text
    popup_text.should match /Day field is required|Required/
    page.cancel_edit(row)
    page.cancel
  end
end

When /^the error displayed for CO-driven exam offerings RSI is that the start time is invalid$/ do
  on ViewExamOfferings do |page|
    row = page.co_target_row
    page.save_edit(row)
    page.loading.wait_while_present
    element = page.rsi_start_time(row)
    element.click
    sleep 1
    popup_text = page.div(id: /jquerybubblepopup/, data_for: "#{element.id}").table.text
    popup_text.should match /Valid time format hh:mm AM or hh:mm PM|Start Time is invalid/
    page.cancel_edit(row)
    page.cancel
  end
end

When /^the error displayed for AO-driven exam offerings RSI end time is required$/ do
  on ViewExamOfferings do |page|
    row = page.ao_eo_target_row(@activity_offering.code)
    element = page.rsi_end_time(row)
    element.click
    sleep 1
    popup_text = page.div(id: /jquerybubblepopup/, data_for: "#{element.id}").table.text
    popup_text.should match /End Time field is required/
    page.cancel_edit(row)
    page.cancel
  end
end

When /^the error displayed for AO-driven exam offerings RSI facility is: (.*?)$/ do |expected_errMsg|
  on ViewExamOfferings do |page|
    row = page.ao_eo_target_row(@activity_offering.code)
    element = page.rsi_facility(row)
    element.click
    sleep 1
    popup_text = page.div(id: /jquerybubblepopup/, data_for: "#{element.id}").table.text
    popup_text.should match /#{expected_errMsg}/
    page.cancel_edit(row)
    page.cancel
  end
end

When /^the error displayed for AO-driven exam offerings RSI room is: (.*?)$/ do |expected_errMsg|
  on ViewExamOfferings do |page|
    row = page.ao_eo_target_row(@activity_offering.code)
    element = page.rsi_room(row)
    element.click
    sleep 1
    popup_text = page.div(id: /jquerybubblepopup/, data_for: "#{element.id}").table.text
    popup_text.should match /#{expected_errMsg}/
    page.cancel_edit(row)
    page.cancel
  end
end

When /^I (?:view|manage) the Exam Offerings for the Course Offering$/ do
  on(ManageCourseOfferings).view_exam_offerings
end

When /^the CO-driven exam offering RSI is successfully updated$/ do
  @course_offering.manage
  on(ManageCourseOfferings).view_exam_offerings
  on ViewExamOfferings do |page|
    page.co_target_row.exists?.should be_true
    page.co_eo_days.should match /#{@eo_rsi.day}/
    page.co_eo_st_time.should == @eo_rsi.start_time
    page.co_eo_end_time.should == @eo_rsi.end_time
    #page.co_eo_bldg.should == @eo_rsi.facility TODO: issue with short vs full facility name
    page.co_eo_room.should == @eo_rsi.room
  end
end

When /^the CO-driven exam offering RSI is updated according to the exam matrix$/ do
  @course_offering.manage
  on(ManageCourseOfferings).view_exam_offerings
  on ViewExamOfferings do |page|
    page.co_target_row.exists?.should be_true
    page.co_eo_days.should match @matrix.rules[0].rsi_days
    page.co_eo_st_time.should == "#{@matrix.rules[0].start_time} #{@matrix.rules[0].st_time_ampm.upcase}"
    page.co_eo_end_time.should == "#{@matrix.rules[0].end_time} #{@matrix.rules[0].end_time_ampm.upcase}"
    #page.co_eo_bldg.should == @matrix.rules[0].facility TODO: issue with short vs full facility name
    page.co_eo_room.should == @matrix.rules[0].room
  end
end

When /^the AO-driven exam offering RSI is updated according to the exam matrix$/ do
  @course_offering.manage
  on(ManageCourseOfferings).view_exam_offerings
  code = @activity_offering.code
  on ViewExamOfferings do |page|
    page.ao_eo_target_row(code).exists?.should be_true
    page.ao_eo_days(code).should match @matrix.rules[0].rsi_days
    page.ao_eo_st_time(code).should == "#{@matrix.rules[0].start_time} #{@matrix.rules[0].st_time_ampm.upcase}"
    page.ao_eo_end_time(code).should == "#{@matrix.rules[0].end_time} #{@matrix.rules[0].end_time_ampm.upcase}"
    #page.ao_eo_bldg(code).should == @eo_rsi.facility TODO: issue with short vs full facility name
    #page.ao_eo_room(code).should == @matrix.rules[0].room
  end
end

When /^the AO-driven exam offering RSI is not updated$/ do
  @course_offering.manage
  on(ManageCourseOfferings).view_exam_offerings
  code = @activity_offering.code
  on ViewExamOfferings do |page|
    page.ao_eo_target_row(code).exists?.should be_true
    page.ao_eo_days(code).should match /#{@eo_rsi.day}/
    page.ao_eo_st_time(code).should == @eo_rsi.start_time
    page.ao_eo_end_time(code).should == @eo_rsi.end_time
    #page.ao_eo_bldg(code).should == @eo_rsi.facility TODO: issue with short vs full facility name
    page.ao_eo_room(code).should == @eo_rsi.room
  end
end

When /^the exam offering RSI is blank according to the new AO RSI information$/ do
  @course_offering.manage
  on(ManageCourseOfferings).view_exam_offerings
  code = @activity_offering.code
  on ViewExamOfferings do |page|
    page.ao_eo_target_row(code).exists?.should be_true
    page.ao_eo_days(code).should == ''
    page.ao_eo_st_time(code).should == ''
    page.ao_eo_end_time(code).should == ''
    page.ao_eo_bldg(code).should == ''
    page.ao_eo_room(code).should == ''
  end
end

When /^the CO-driven exam offering RSI is not updated$/ do
  @course_offering.manage
  on(ManageCourseOfferings).view_exam_offerings
  on ViewExamOfferings do |page|
    page.co_target_row.exists?.should be_true
    page.co_eo_days.should match /#{@eo_rsi.day}/
    page.co_eo_st_time.should == @eo_rsi.start_time
    page.co_eo_end_time.should == @eo_rsi.end_time
    #page.co_eo_bldg.should == @eo_rsi.facility TODO: issue with short vs full facility name
    page.co_eo_room.should == @eo_rsi.room
  end
end

When /^the AO-driven exam offering RSI is successfully updated$/ do
  @course_offering.manage
  on(ManageCourseOfferings).view_exam_offerings
  ao_code = @eo_rsi.ao_code
  on ViewExamOfferings do |page|
    page.ao_eo_target_row(ao_code).exists?.should be_true
    page.ao_eo_days(ao_code).should match /#{@eo_rsi.day}/
    page.ao_eo_st_time(ao_code).should == @eo_rsi.start_time
    page.ao_eo_end_time(ao_code).should == @eo_rsi.end_time
    #page.ao_eo_bldg(ao_code).should == @eo_rsi.facility TODO: issue with short vs full facility name
    page.ao_eo_room(ao_code).should == @eo_rsi.room
  end
end

When /^I suspend an Activity Offering for a CO with a standard final exam driven by Course Offering$/ do
  @original_co = engl301_published_eo_create_term

  @course_offering = @original_co.copy
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Course Offering"

  @course_offering.initialize_with_actual_values
  @activity_offering = @course_offering.activity_offering_cluster_list[0].ao_list[0]
  # @course_offering.find_ao_obj_by_code('A')
  @activity_offering.suspend :navigate_to_page => false
end

When /^I suspend the Course Offering for a CO with a standard final exam driven by Course Offering$/ do
  @original_co = engl301_published_eo_create_term

  @course_offering = @original_co.copy
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Course Offering"

  on ManageCourseOfferings do |page|
    page.cluster_select_all_aos
    page.suspend_ao
    on(SuspendActivityOffering).suspend_activity
  end
end

When /^I suspend all Activity Offerings for a CO with a standard final exam driven by Course Offering$/ do
  @original_co = engl301_published_eo_create_term


  @course_offering = @original_co.copy
  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Course Offering"

  on ManageCourseOfferings do |page|
    page.cluster_select_all_aos
    page.suspend_ao
    on(SuspendActivityOffering).suspend_activity
  end
end

When /^I suspend an Activity Offering for a CO with a standard final exam driven by Activity Offering$/ do
  @original_co = engl301_published_eo_create_term

  @course_offering = @original_co.copy
  @course_offering.delivery_format_list[0].format = "Lecture"
  @course_offering.delivery_format_list[0].grade_format = "Lecture"
  @course_offering.delivery_format_list[0].final_exam_activity = "Lecture"

  @course_offering.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Activity Offering"

  @course_offering.initialize_with_actual_values
  @activity_offering = @course_offering.find_ao_obj_by_code('A')
  @activity_offering.suspend :navigate_to_page => false
end

Then /^a warning in the Final Exam Period section is displayed stating "([^"]*)"$/ do |exp_msg|
  on EditAcademicTerms do |page|
    page.get_exam_warning_message( @calendar.terms[0].term_type).should match /#{exp_msg}/
    page.cancel
  end
end

Then /^an error in the Final Exam section is displayed stating "([^"]*)"$/ do |exp_msg|
  on EditAcademicTerms do |page|
    page.get_exam_error_message( @calendar.terms[0].term_type).should match /#{exp_msg}/
  end
end

Then /^no error in the Final Exam section is displayed when I save the data$/ do
  on EditAcademicTerms do |page|
    page.exam_error_message( @calendar.terms[0].term_type).present?.should be_false
    page.cancel
  end
end

Then /^the final exam period for the Fall Term is listed when I view the Academic Calendar$/ do
  @calendar.search

  on(CalendarSearch).view @calendar.name

  on ViewAcademicTerms do |page|
    page.go_to_terms_tab
    page.open_term_section(@calendar.terms[0].term_type)
    page.term_start_date_element(@calendar.terms[0].term_type).focus
    page.exam_target_row( @calendar.terms[0].term_type).wait_until_present
    page.get_exam_start_date( @calendar.terms[0].term_type).should match /12\/11\/#{@calendar.year}/
    page.get_exam_end_date( @calendar.terms[0].term_type).should match /12\/20\/#{@calendar.year}/
  end
end

Then /^there should be no final exam period for any term in the copy$/ do
  all_terms = @calendar.get_all_term_names_in_calendar
  on EditAcademicTerms do |page|
    all_terms.each do |term_name|
      page.open_term_section(term_name)
      page.add_exam_period_btn( term_name).focus
      page.add_exam_period_btn( term_name).present?.should be_true
    end
    page.cancel
  end
end

When /^I change the Final Exam indicator from Standard Final Exam to Alternate Final Assessment or No Final Exam or Assessment$/ do
  on CourseOfferingCreateEdit do |page|
    page.final_exam_option_alternate
    page.new_final_exam_driver_value.should == ''
    page.final_exam_option_none
    page.new_final_exam_driver_value.should == ''
  end
end

When /^I change the Final Exam indicator from Alternate Final Assessment to Standard Final Exam$/ do
  on CourseOfferingCreateEdit do |page|
    page.final_exam_option_standard
    page.final_exam_driver_select "Final Exam Per Activity Offering"
  end
end

When /^I change the Final Exam indicator from No Final Exam or Assessment to Standard Final Exam$/ do
  on CourseOfferingCreateEdit do |page|
    page.final_exam_option_standard
    page.final_exam_driver_select "Final Exam Per Course Offering"
  end
end

Then /^the Final Exam Driver should not be Activity Offering or Course Offering$/ do
  on CourseOfferingCreateEdit do |page|
    page.new_final_exam_driver_value.should_not == "Activity Offering"
    page.new_final_exam_driver_value.should_not == "Course Offering"
  end
end

Then /^the Final Exam Driver Activity field should disappear$/ do
  on CourseOfferingCreateEdit do |page|
    exam_driver_activity_label = page.delivery_formats_table.rows[0].cells[3].text
    exam_driver_activity_label.should_not match /FINAL EXAM DRIVER ACTIVITY/
    page.cancel
  end
end

Then /^the Final Exam Driver should allow the user to pick Activity Offering or Course Offering as the exam driver$/ do
  on CourseOfferingCreateEdit do |page|
    page.final_exam_driver_element.option(value: /ActivityOffering/).text.should == "Final Exam Per Activity Offering"
    page.final_exam_driver_element.option(value: /CourseOffering/).text.should == "Final Exam Per Course Offering"
  end
end

Then /^the Final Exam Driver Activity field should appear if Activity Offering is selected as the exam driver$/ do
  on CourseOfferingCreateEdit do |page|
    page.final_exam_driver_select "Final Exam Per Activity Offering"
    exam_driver_activity_label = page.delivery_formats_table.rows[0].cells[3].text
    exam_driver_activity_label.should match /Final Exam Driver Activity/
    page.new_final_exam_driver_value.should == "Activity Offering"
    page.cancel
  end
end

Then /^the option to specify a Final Exam Driver should only be available for a course offering with a Standard Final Exam option selected$/ do
  on CourseOfferingCreateEdit do |page|
    page.final_exam_option_standard
    page.final_exam_driver_element.present?.should == true
    page.final_exam_option_alternate
    page.final_exam_driver_element.present?.should == false
    page.final_exam_option_none
    page.final_exam_driver_element.present?.should == false
    page.create_offering
  end
end

Then /^a warning about the FE on the Edit CO page is displayed stating "([^"]*)"$/ do |exp_msg|
  on(CourseOfferingCreateEdit).delivery_assessment_warning.should match /#{exp_msg}/
end

Then /^the status of the Final Exam Driver should change to indicate the driver chosen for the Standard Final Exam$/ do
  on CourseOfferingCreateEdit do |page|
    page.final_exam_option_standard
    page.final_exam_driver_select "Final Exam Per Activity Offering"
    page.new_final_exam_driver_value.should == "Activity Offering"
    page.final_exam_driver_select "Final Exam Per Course Offering"
    page.new_final_exam_driver_value.should == "Course Offering"
    page.create_offering
  end
end

Then /^the Final Exam Driver delivery format value should reflect the value selected in the Final Exam Driver field dropdown$/ do
  on(CourseOfferingCreateEdit).new_final_exam_driver_value.should == "Activity Offering"
end

Then /^the Final Exam Driver Activity field should exist and be populated with the first activity type of the format offering$/ do
  on CourseOfferingCreateEdit do |page|
    page.new_final_exam_activity_value.should == "Lecture"
    page.cancel
  end
end

Then /^I should be able to edit and update the Final Exam status$/ do
  on CourseOfferingCreateEdit do |page|
    page.final_exam_option_none
    page.new_final_exam_driver_value.should == "No final exam for this offering"
    page.submit
  end
end

Then /^the exam data for the newly created course offering should match that of the original$/ do
  on(CourseOfferingCreateEdit).new_final_exam_driver_value.should == "Activity Offering"
end

Then /^the ability to access the Use Final Exam Matrix field should only be available for a course offering set to have a Standard Final Exam$/ do
  on CourseOfferingCreateEdit do |page|
    page.final_exam_option_standard
    page.use_exam_matrix_div.present?.should == true
    page.final_exam_option_alternate
    page.use_exam_matrix_div.present?.should == false
    page.final_exam_option_none
    page.use_exam_matrix_div.present?.should == false
    page.cancel
  end
end

Then /^I should not be able to update the status of the final exam period$/ do
  on CourseOfferingCreateEdit do |page|
    page.final_exam_option_div.radio(value: "STANDARD").present?.should == false
    page.final_exam_option_div.radio(value: "ALTERNATE").present?.should == false
    page.final_exam_option_div.radio(value: "NONE").present?.should == false
    page.final_exam_option_div.text.should == "Exam Type\nStandard Final Exam"
    page.cancel
  end
end

Then /^I do not have access to the final exam status for the course offering from catalog$/ do
  on CreateCourseOffering do |page|
    page.choose_from_catalog
    page.continue
  end

  on CourseOfferingCreateEdit do |page|
    page.final_exam_option_div.radio(value: "STANDARD").present?.should == false
    page.final_exam_option_div.radio(value: "ALTERNATE").present?.should == false
    page.final_exam_option_div.radio(value: "NONE").present?.should == false
    page.final_exam_option_div.text.should == "Exam Type\nStandard Final Exam"
  end
end

Then /^all the exam settings and messages are retained after the rollover is completed for the courses that were rolled over$/ do
  @test_co_list = []
  @test_co_list << (make CourseOffering, :term => @calendar_target.terms[0].term_code, :course => @co_list[0].course)
  @test_co_list[0].manage
  on(ManageCourseOfferings).edit_course_offering
  on CourseOfferingCreateEdit do |page|
    page.delivery_assessment_warning.should == "Course exam data differs from Catalog."
  end

  @test_co_list << (make CourseOffering, :term => @calendar_target.terms[0].term_code, :course => @co_list[1].course)
  @test_co_list[1].manage
  on(ManageCourseOfferings).edit_course_offering
  on CourseOfferingCreateEdit do |page|
    page.delivery_assessment_warning.should == "Course exam data differs from Catalog."
  end


  @test_co_list << (make CourseOffering, :term => @calendar_target.terms[0].term_code, :course => @co_list[2].course)
  @test_co_list[2].manage
  on(ManageCourseOfferings).edit_course_offering
  on(CourseOfferingCreateEdit).new_final_exam_driver_value.should == "Activity Offering"

  @test_co_list << (make CourseOffering, :term => @calendar_target.terms[0].term_code, :course => @co_list[3].course)
  @test_co_list[3].manage
  on(ManageCourseOfferings).edit_course_offering
  on(CourseOfferingCreateEdit).cancel
end

Then /^the Exam Offerings for Course Offering should be in a ([^"]*) state$/ do |exp_state|
  on ViewExamOfferings do |page|
    page.table_header_text.should match /for Course Offering/
    page.co_eo_status.should match /#{exp_state}/
    page.co_eo_count.should == "1"
  end
end

Then /^the EO in the Exam Offerings for Course Offering table should be in a ([^"]*) state$/ do |exp_state|
  on ViewExamOfferings do |page|
    page.table_header_text.should match /for Course Offering/
    page.co_eo_status.should match /#{exp_state}/
    page.co_eo_count.should == "1"
  end
end

Then /^there should only be one EO in the Exam Offerings for Course Offering table$/ do
  on(ViewExamOfferings).co_eo_count.should == "1"
end

Then /^the Exam Offerings for Course Offering in the EO for CO table should be in a ([^"]*) state$/ do |exp_state|
  on ViewExamOfferings do |page|
    page.table_header_text.should match /for Course Offering/
    page.co_eo_status.should match /#{exp_state}/
    page.co_eo_count.should == "1"
  end
end

Then /^the Exam Offerings for each Activity Offering in the EO for AO table should be in a ([^"]*) state$/ do |exp_state|
  on ViewExamOfferings do |page|
    page.table_header_text.should match /for Activity Offering/
    @course_offering.activity_offering_cluster_list.each do |cluster|
      cluster.ao_list.each do |ao|
        page.ao_eo_status(ao.code).should match /#{exp_state}/ if ao.activity_type == @course_offering.delivery_format_list[0].final_exam_activity
      end
    end
  end
end

Then /^the Exam Offering for Activity Offering should not be in a ([^"]*) state$/ do |exp_state|
  on ViewExamOfferings do |page|
    page.table_header_text.should match /for Activity Offering/
    array = page.ao_code_list
    array.each do |code|
      page.ao_eo_status(code).should_not match /#{exp_state}/
    end
  end
end

Then /^the Exam Offerings? for Activity Offering should be in a ([^"]*) state$/ do |exp_state|
  on ViewExamOfferings do |page|
    page.table_header_text.should match /for Activity Offering/
    array = page.ao_code_list
    if array != nil
      array.each do |code|
        page.ao_eo_status(code).should match /#{exp_state}/
      end
      no_of_eos = array.length
    end
    array = page.ao_code_list("CL Leftovers")
    if array != nil
      array.each do |code|
        page.ao_eo_status(code, "CL Leftovers").should match /#{exp_state}/
      end
      no_of_eos = array.length
    end
    no_of_eos.should == 1
  end
end

Then /^the EO for the suspended AO in the Exam Offering for Activity Offering table should be in a ([^"]*) state$/ do |exp_state|
  on ViewExamOfferings do |page|
    page.table_header_text.should match /for Activity Offering/
    no_of_eos = 0
    array = page.ao_code_list
    if array != nil
      array.each do |code|
        if code == @activity_offering.code
          page.ao_eo_status(code).should match /#{exp_state}/
          no_of_eos += 1
        end
      end
    end
    array = page.ao_code_list("CL Leftovers")
    if array != nil
      array.each do |code|
        if code == @activity_offering.code
          page.ao_eo_status(code, "CL Leftovers").should match /#{exp_state}/
          no_of_eos += 1
        end
      end
    end
    no_of_eos.should == 1
  end
end

Then /^the EOs in the Exam Offerings for Activity Offering table should be in a ([^"]*) state$/ do |exp_state|
  #TODO: should be driven by @course_offering object
  on ViewExamOfferings do |page|
    page.table_header_text.should match /for Activity Offering/
    @course_offering.activity_offering_cluster_list.each do |cluster|
      cluster.ao_list.each do |ao|
        page.ao_eo_status(ao.code).should match /#{exp_state}/ if ao.activity_type == @course_offering.delivery_format_list[0].final_exam_activity
      end
    end
  end
end

Then /^there should be one EO for each AO of the course in the Exam Offering for Activity Offering table$/ do
  on ViewExamOfferings do |page|
    array = page.ao_code_list
    if array != nil
      no_of_eos = array.length
    end
    array = page.ao_code_list("CL Leftovers")
    if array != nil
      no_of_eos = array.length
    end
    no_of_eos.should >= 1
  end
end

Then /^the ([\d]*) Exam Offerings? for Activity Offering should be in a ([^"]*) state$/ do |num,exp_state|
  on ViewExamOfferings do |page|
    page.ao_table_header_text.should match /for Activity Offering/
    array = page.ao_code_list
    if array != nil
      array.each do |code|
        page.ao_eo_status(code).should match /#{exp_state}/
      end
      no_of_eos = array.length
    end
    array = page.ao_code_list("CL Leftovers")
    if array != nil
      array.each do |code|
        page.ao_eo_status(code, "CL Leftovers").should match /#{exp_state}/
      end
      no_of_eos = array.length
    end
    no_of_eos.should == num
  end
end

Then /^there should be ([^"]*) Exam Offerings? by Activity Offering for the course$/ do |no_of_aos|
  on ViewExamOfferings do |page|
    array = page.ao_code_list
    array.length.should == no_of_aos.to_i
  end
end

Then /^there should be ([\d]*) EOs in the Exam Offerings by Activity Offering table for the course$/ do |no_of_aos|
  on ViewExamOfferings do |page|
    array = page.ao_code_list
    array.length.should == no_of_aos.to_i
  end
end

Then /^there should be no View Exam Offering option present$/ do
  on ManageCourseOfferings do |page|
    page.view_exam_offerings_link.present?.should == false
  end
  #on ViewExamOfferings do |page|
  #  page.exam_offerings_page_section.text.should_not match /^Exam Offerings for Course Offering/
  #  page.exam_offerings_page_section.text.should_not match /^Exam Offerings for Activity Offering/
  #end
end

Then /^I expect a popup to appear with a displayed warning stating "([^"]*)"$/ do |exp_msg|
  on PerformRollover do |page|
    page.continue_wo_exams_dialog_div.visible?.should == true
    page.continue_wo_exams_dialog_div.text.should match /#{exp_msg}/
    page.continue_wo_exams_dialog_confirm
  end
end

Then /^the Exclude Saturday and Exclude Sunday toggles should be selected by default$/ do
  on EditAcademicTerms do |page|
    page.exclude_saturday_toggle( @calendar.terms[0].term_type).attribute_value('checked').should == "true"
    page.exclude_sunday_toggle( @calendar.terms[0].term_type).attribute_value('checked').should == "true"
  end
end

Then /^the Exclude Saturday or Exclude Sunday fields should be deselected when view the term$/ do
  @calendar.terms[0].search
  on(CalendarSearch).view @calendar.terms[0].term_name
  on ViewAcademicTerms do |page|
    page.open_term_section(@calendar.terms[0].term_type)
    sleep 5
    page.get_exclude_saturday_value(@calendar.terms[0].term_type).should_not == "Yes"
    page.get_exclude_sunday_value(@calendar.terms[0].term_type).should_not == "Yes"
  end
end

Then /^the Exam Offering listed in the EO for CO table should be in a ([^"]*) state$/ do |exp_msg|
  on(ViewExamOfferings).co_eo_status.should =~ /#{exp_msg}/
end

Then /^the Exam Offering table should be in a Canceled state$/ do
  on(ViewExamOfferings).exam_offerings_page_section.text.should match /Cancelled Exam Offerings for Activity Offerings/
end

Then /^the EO in the Exam Offering by Course Offering table should be in a Canceled state$/ do
  on(ViewExamOfferings).exam_offerings_page_section.text.should match /Cancelled Exam Offerings? for Course Offerings?/
end

Then /^the EO in the Exam Offering by Activity Offering table should be in a Canceled state$/ do
  on(ViewExamOfferings).exam_offerings_page_section.text.should match /Cancelled Exam Offerings for Activity Offerings/
end

Then /^the header for the table should be labelled as Canceled$/ do
  on(ViewExamOfferings).exam_offerings_page_section.text.should match /Cancelled Exam Offerings for Activity Offerings/
end

Then /^there should be an Activity Offering table header explaining that the Exam Offerings have been canceled$/ do
  on(ViewExamOfferings).exam_offerings_page_section.text.should match /Cancelled Exam Offerings for Activity Offerings/
end

Then /^there should be no Exam Offering for Course Offering table present$/ do
  on(ViewExamOfferings).table_header_text.should_not match /for Course Offerings/
end

Then /^there should be no Exam Offering for Activity Offering table present$/ do
  on(ViewExamOfferings).table_header_text.should_not match /for Activity Offerings/
end

Then /^the Exam Offering table for the canceled AO should also be in the same state$/ do
  on(ViewExamOfferings).ao_eo_status('A').should == 'Canceled'
end

Given /^that a CO allows for multiple Format Offerings and has one existing format offering and a standard exam driven by Course Offering$/ do
  @original_co = engl304_published_eo_create_term

  @course_offering = @original_co.copy
end

When /^I edit the CO to add a second Format Offering$/ do
  delivery_format = make DeliveryFormatObject, :format => "Lecture", :grade_format => "Course Offering", :final_exam_activity => "Lecture"
  @course_offering.add_delivery_format :delivery_format => delivery_format
end

When /^I create a Course Offering from copy in a term that uses the matrix and has a final exam period defined$/ do
  @copy_co = @course_offering.copy

  @copy_co.edit :final_exam_type => "Standard Final Exam",
                                 :final_exam_driver => "Final Exam Per Course Offering"
end

When /^I create a Course Offering from copy in a term with a defined final exam period that uses the FE matrix$/ do
  @copy_co = @course_offering.copy
end

Then /^there should be a warning message stating that "(.*?)"$/ do |exp_msg|
  on ManageCourseOfferings do |page|
    begin
      page.wait_until(120) { page.growl_warning_text.exists? }
      page.growl_warning_text.should match /#{@course_offering.course}.*#{Regexp.escape(exp_msg)}/
    rescue
      puts "growl warning message for the EO did not appear"
    end
  end
end

Then /^there should be a warning message for the AO stating that "(.*?)"$/ do |exp_msg|
  on ManageCourseOfferings do |page|
    begin
      page.wait_until(120) { page.growl_message_warning_div.exists? }
      page.growl_warning_text.should match /#{@course_offering.course}.*#{@course_offering.activity_offering_cluster_list[0].ao_list[0].code}.*#{Regexp.escape(exp_msg)}/
    rescue
      puts "growl warning message for the EO did not appear"
    end
  end
end

When /^I create a Course Offering from catalog in a term with a defined final exam period that uses the FE matrix$/ do
  @course_offering.create
end

And /^I have created a Course Offering from catalog in the source term that uses the matrix and has a final exam period defined$/ do
  @course_offering = create CourseOffering, :term => @calendar.terms[0].term_code, :course => "HIST110"
end

And /^I have created an Activity Offering that only has Requested Scheduling Information$/ do
  @activity_offering = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject)
  si_obj =  make SchedulingInformationObject, :days => "MWF",
                 :start_time => "01:00", :start_time_ampm => "pm",
                 :end_time => "01:50", :end_time_ampm => "pm"
  @activity_offering.add_req_sched_info :rsi_obj => si_obj
end

When /^I create a Course Offering from copy in a term with a defined final exam period that uses the matrix$/ do
  @course_offering = @original_co.copy
  @course_offering.initialize_with_actual_values
  @activity_offering = @course_offering.activity_offering_cluster_list[0].ao_list[0]
end

When /^I create a copy of the initial course offering in a term that uses the FE matrix and has defined final exam period$/ do
  @course_offering = @original_co.copy
  @course_offering.initialize_with_actual_values
  @activity_offering = @course_offering.activity_offering_cluster_list[0].ao_list[0]
end

Given /^I create a Course Offering with an AO-driven exam from catalog in a term with a defined final exam period$/ do
  @course_offering = make CourseOffering, :term => "201301", :course => "BSCI361",
                            :final_exam_driver => "Final Exam Per Activity Offering"
  @course_offering.delivery_format_list[0].format = "Lecture"
  @course_offering.delivery_format_list[0].grade_format = "Lecture"
  @course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
  @course_offering.create
end

Given /^that the Course Offering has an AO-driven exam in a term that uses the FE matrix and has defined final exam period$/ do
  @original_co = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "BSCI361"

  unless @original_co.exists?
    course_offering = make CourseOffering, :term=> Rollover::OPEN_EO_CREATE_TERM,
                           :course => "BSCI361",
                           :suffix => ' ',
                           :final_exam_driver => "Final Exam Per Activity Offering"
    course_offering.delivery_format_list[0].format = "Lecture/Discussion"
    course_offering.delivery_format_list[0].grade_format = "Discussion"
    course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
    course_offering.create

    activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                               :format => "Lecture/Discussion", :activity_type => "Lecture"
    si_obj =  make SchedulingInformationObject, :days => "MW",
                   :start_time => "02:00", :start_time_ampm => "pm",
                   :end_time => "03:15", :end_time_ampm => "pm",
                   :facility => 'PLS', :room => '1130'
    activity_offering.add_req_sched_info :rsi_obj => si_obj

    #TODO: KSENROLL-13157 problems creating 2nd AO
    # activity_offering = create ActivityOfferingObject, :parent_course_offering => course_offering,
    #                            :format => "Lecture/Discussion", :activity_type => "Discussion"
    # si_obj =  make SchedulingInformationObject, :days => "W",
    #                :start_time => "09:00", :start_time_ampm => "am",
    #                :end_time => "09:50", :end_time_ampm => "am",
    #                :facility => 'KEY', :room => '0117'
    # activity_offering.add_req_sched_info :rsi_obj => si_obj
  end

  end

When /^I create a copy of the Course Offering and decide to exclude all scheduling information$/ do
  @course_offering = @original_co.copy :exclude_scheduling => true
  @course_offering.initialize_with_actual_values
  @activity_offering = @course_offering.activity_offering_cluster_list[0].ao_list[0]
end

Given /^I create an Activity Offering that has no ASIs or RSIs$/ do
  @activity_offering = make ActivityOfferingObject, :activity_type => "Lecture", :parent_cluster => @course_offering.default_cluster
  @activity_offering = @activity_offering.create_simple[0]
  @activity_offering.approve :navigate_to_page => false
end

Given /^I create an Activity Offering that has RSI data but has no ASI data$/ do
  @activity_offering = make ActivityOfferingObject, :activity_type => "Lecture", :parent_cluster => @course_offering.default_cluster
  @activity_offering = @activity_offering.create_simple[0]
  @activity_offering.approve :navigate_to_page => false

  @course_offering.manage
  end_time = (DateTime.strptime("#{@matrix.rules[0].statements[0].start_time}", '%I:%M') + ("50".to_f/1440)).strftime( '%I:%M')
  @activity_offering.add_req_sched_info :rsi_obj => (make SchedulingInformationObject, :days  => "T",
                                                          :start_time  => @matrix.rules[0].statements[0].start_time,
                                                          :start_time_ampm  => @matrix.rules[0].statements[0].st_time_ampm,
                                                          :end_time  => end_time, :end_time_ampm => @matrix.rules[0].statements[0].st_time_ampm)
end

When /^I add additional Requested Scheduling Information to the Activity Offering that matches an entry on the exam matrix$/ do
  @course_offering.manage
  end_time = (DateTime.strptime("#{@matrix.rules[0].statements[0].start_time}", '%I:%M') + ("50".to_f/1440)).strftime( '%I:%M')
  @activity_offering.add_req_sched_info :rsi_obj => (make SchedulingInformationObject, :days  => "H",
                                                          :start_time  => @matrix.rules[0].statements[0].start_time,
                                                          :start_time_ampm  => @matrix.rules[0].statements[0].st_time_ampm,
                                                          :end_time  => end_time, :end_time_ampm => @matrix.rules[0].statements[0].st_time_ampm)
end

When /^I add new Requested Scheduling Information to the Activity Offering that does not match an entry on the exam matrix$/ do
  @course_offering.manage
  end_time = (DateTime.strptime("#{@matrix.rules[0].statements[0].start_time}", '%I:%M') + ("50".to_f/1440)).strftime( '%I:%M')

  rsi_object = make SchedulingInformationObject, :days  => "F", :start_time  => @matrix.rules[0].statements[0].start_time,
                    :start_time_ampm  => @matrix.rules[0].statements[0].st_time_ampm,
                    :end_time  => end_time, :end_time_ampm  => @matrix.rules[0].statements[0].st_time_ampm

  @activity_offering.add_req_sched_info :rsi_obj => rsi_object
end

When /^I add new Requested Scheduling Information to the Activity Offering that matches an entry on the exam matrix$/ do
  @course_offering.manage
  end_time = (DateTime.strptime("#{@matrix.rules[0].statements[0].start_time}", '%I:%M') + ("50".to_f/1440)).strftime( '%I:%M')

  rsi_object = make SchedulingInformationObject, :days  => @matrix.rules[0].statements[0].days,
                    :start_time  => @matrix.rules[0].statements[0].start_time,
                    :start_time_ampm  => @matrix.rules[0].statements[0].st_time_ampm,
                    :end_time  => end_time, :end_time_ampm  => @matrix.rules[0].statements[0].st_time_ampm

  @activity_offering.add_req_sched_info :rsi_obj => rsi_object
end

When /^I create multiple course offerings with AO-driven exams with scheduling information matching and not matching entries on the exam matrix$/ do
   @matrix = make FinalExamMatrix
   @matrix.create_standard_rule_matrix_object_for_rsi( "TH")
   @matrix.create_standard_rule_matrix_object_for_rsi( "F")
   th_end_time = (DateTime.strptime("#{@matrix.rules[0].statements[0].start_time}", '%I:%M') + ("50".to_f/1440)).strftime( '%I:%M')
   f_end_time = (DateTime.strptime("#{@matrix.rules[1].statements[0].start_time}", '%I:%M') + ("50".to_f/1440)).strftime( '%I:%M')

  #AO-driven, 'A' match on matrix, 'B' no match on matrix
  @course_offering_ao_driven = make CourseOffering, :term => @calendar.terms[0].term_code, :course => "ENGL313",
      :final_exam_driver => "Final Exam Per Activity Offering"
  @course_offering_ao_driven.delivery_format_list[0].format = "Lecture"
  @course_offering_ao_driven.delivery_format_list[0].grade_format = "Lecture"
  @course_offering_ao_driven.delivery_format_list[0].final_exam_activity = "Lecture"
  @course_offering_ao_driven.create

  ao = make ActivityOfferingObject, :format => "Lecture Only"
  @course_offering_ao_driven.create_ao :ao_obj => ao
  ao.add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
                                                :days  => @matrix.rules[0].statements[0].days,
                                                :start_time  => @matrix.rules[0].statements[0].start_time,
                                                :start_time_ampm  => @matrix.rules[0].statements[0].st_time_ampm,
                                                :end_time  => th_end_time, :end_time_ampm  => @matrix.rules[0].statements[0].st_time_ampm)

  ao = make ActivityOfferingObject, :format => "Lecture Only"
  @course_offering_ao_driven.create_ao :ao_obj => ao
  ao.add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
                                                :days  => @matrix.rules[1].statements[0].days,
                                                :start_time  => @matrix.rules[1].statements[0].start_time,
                                                :start_time_ampm  => @matrix.rules[1].statements[0].st_time_ampm,
                                                :end_time  => f_end_time, :end_time_ampm  => @matrix.rules[1].statements[0].st_time_ampm)
  #AO-driven no scheduling info
  @course_offering_no_rsi = make CourseOffering, :term => @calendar.terms[0].term_code, :course => "CHEM242",
                    :final_exam_driver => "Final Exam Per Activity Offering"
  @course_offering_no_rsi.delivery_format_list[0].format = "Lab/Lecture"
  @course_offering_no_rsi.delivery_format_list[0].grade_format = "Lecture"
  @course_offering_no_rsi.delivery_format_list[0].final_exam_activity = "Lecture"
  @course_offering_no_rsi.create

  @course_offering_no_rsi.create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lab/Lecture" )

   #AO-driven, 'A' match on matrix, 'B' no match on matrix BUT off matrix
   @course_offering_ao_driven_off_matrix = make CourseOffering, :term => @calendar.terms[0].term_code,
                                                :course => "ENGL313",
                                                :final_exam_driver => "Final Exam Per Activity Offering",
                                                :use_final_exam_matrix => false
   @course_offering_ao_driven_off_matrix.delivery_format_list[0].format = "Lecture"
   @course_offering_ao_driven_off_matrix.delivery_format_list[0].grade_format = "Lecture"
   @course_offering_ao_driven_off_matrix.delivery_format_list[0].final_exam_activity = "Lecture"
   @course_offering_ao_driven_off_matrix.create

   ao = make ActivityOfferingObject, :format => "Lecture Only"
   @course_offering_ao_driven_off_matrix.create_ao :ao_obj => ao
   ao.add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
                                           :days  => @matrix.rules[0].statements[0].days,
                                           :start_time  => @matrix.rules[0].statements[0].start_time,
                                           :start_time_ampm  => @matrix.rules[0].statements[0].st_time_ampm,
                                           :end_time  => th_end_time, :end_time_ampm  => @matrix.rules[0].statements[0].st_time_ampm)

   ao = make ActivityOfferingObject, :format => "Lecture Only"
   @course_offering_ao_driven_off_matrix.create_ao :ao_obj => ao
   ao.add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
                                           :days  => @matrix.rules[1].statements[0].days,
                                           :start_time  => @matrix.rules[1].statements[0].start_time,
                                           :start_time_ampm  => @matrix.rules[1].statements[0].st_time_ampm,
                                           :end_time  => f_end_time, :end_time_ampm  => @matrix.rules[1].statements[0].st_time_ampm)

end

When /^I create multiple course offerings with CO-driven exams with course codes matching and not matching entries on the exam matrix$/ do
  @matrix_com = make FinalExamMatrix
  @matrix_com.create_common_rule_matrix_object_for_rsi( "CHEM277")
  @matrix_com.create_common_rule_matrix_object_for_rsi( "PHYS161")

  #CO-driven no match on matrix
  @course_offering_co_driven = create CourseOffering, :term => @calendar.terms[0].term_code,
                                     :course => "CHEM277",
                                     :final_exam_driver => "Final Exam Per Course Offering"
  #CO-driven no match on matrix
  @course_offering_co_driven_match = make CourseOffering, :term => @calendar.terms[0].term_code,
                                         :course => "PHYS161",
                                         :final_exam_driver => "Final Exam Per Course Offering"
  @course_offering_co_driven_match.delivery_format_list[0].format = "Lecture/Discussion"
  @course_offering_co_driven_match.delivery_format_list[0].grade_format = "Lecture"
  @course_offering_co_driven_match.create

  # course_offering_co_driven_match.create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture/Discussion", :activity_type => "Lecture")
  # course_offering_co_driven_match.activity_offering_cluster_list[0].ao_list[0].add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
  #                                               :days  => @matrix.rules[2].statements[0].days,
  #                                               :start_time  => @matrix.rules[2].statements[0].start_time,
  #                                               :start_time_ampm  => @matrix.rules[2].statements[0].st_time_ampm,
  #                                               :end_time  => th_end_time, :end_time_ampm  => @matrix.rules[2].statements[0].st_time_ampm)
  #
  # course_offering_co_driven_match.create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture/Discussion", :activity_type => "Lecture")
  # course_offering_co_driven_match.activity_offering_cluster_list[0].ao_list[1].add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
  #                                               :days  => @matrix.rules[3].statements[0].days,
  #                                               :start_time  => @matrix.rules[3].statements[0].start_time,
  #                                               :start_time_ampm  => @matrix.rules[3].statements[0].st_time_ampm,
  #                                               :end_time  => f_end_time, :end_time_ampm  => @matrix.rules[3].statements[0].st_time_ampm)
  #
  # course_offering_co_driven_match.create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture/Discussion", :activity_type => "Discussion")

  # course_offering = make CourseOffering, :term => @calendar.terms[0].term_code, :course => "ENGL362",
  #                        :final_exam_driver => "Final Exam Per Activity Offering"
  # course_offering.delivery_format_list[0].format = "Lecture"
  # course_offering.delivery_format_list[0].grade_format = "Course Offering"
  # course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
  # @co_list << (course_offering.create)

  #CO-driven dont use exam matrix - using course code with not match
  @course_offering_co_driven_off_matrix = create CourseOffering, :term => @calendar.terms[0].term_code,
                                          :course => "CHEM277",
                                          :final_exam_driver => "Final Exam Per Course Offering",
                                          :use_final_exam_matrix => false

  #
  # @co_list[2].create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture Only")
  # @co_list[2].activity_offering_cluster_list[0].ao_list[0].add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
  #                                               :days  => @matrix.rules[2].statements[0].days,
  #                                               :start_time  => @matrix.rules[2].statements[0].start_time,
  #                                               :start_time_ampm  => @matrix.rules[2].statements[0].st_time_ampm,
  #                                               :end_time  => th_end_time, :end_time_ampm  => @matrix.rules[2].statements[0].st_time_ampm)
  #
  # @co_list[2].create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture Only")
  # @co_list[2].activity_offering_cluster_list[0].ao_list[1].add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
  #                                               :days  => @matrix.rules[3].statements[0].days,
  #                                               :start_time  => @matrix.rules[3].statements[0].start_time,
  #                                               :start_time_ampm  => @matrix.rules[3].statements[0].st_time_ampm,
  #                                               :end_time  => f_end_time, :end_time_ampm  => @matrix.rules[3].statements[0].st_time_ampm)
  #
  # @co_list[2].create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture Only")
  #
  # course_offering = make CourseOffering, :term => @calendar.terms[0].term_code, :course => "PHYS171",
  #                        :final_exam_driver => "Final Exam Per Activity Offering"
  # course_offering.delivery_format_list[0].format = "Lecture"
  # course_offering.delivery_format_list[0].grade_format = "Course Offering"
  # course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
  # @co_list << (course_offering.create)
  #
  # @co_list[3].create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture Only")
  # @co_list[3].activity_offering_cluster_list[0].ao_list[0].add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
  #                                               :days  => @matrix.rules[3].statements[0].days,
  #                                               :start_time  => @matrix.rules[3].statements[0].start_time,
  #                                               :start_time_ampm  => @matrix.rules[3].statements[0].st_time_ampm,
  #                                               :end_time  => f_end_time, :end_time_ampm  => @matrix.rules[3].statements[0].st_time_ampm)
end

Given /^I create a Course Offering from catalog with an Alternate Exam that is not found on the matrix in a term with a defined final exam period$/ do
  @course_offering = create CourseOffering, :term=> Rollover::PUBLISHED_EO_CREATE_TERM, :course => "CHEM242", :final_exam_type => "ALTERNATE"
end

Given /^I create a Course Offering from catalog with No Exam that is found on the matrix in a term with a defined final exam period$/ do
  @course_offering = make CourseOffering, :term=> Rollover::PUBLISHED_EO_CREATE_TERM, :course => "ENGL403", :final_exam_type => "NONE"

  @matrix = make FinalExamMatrix
  @matrix.create_common_rule_matrix_object_for_rsi( @course_offering.course)

  @course_offering.create
end

When /^I edit the Course Offering to use a Standard Exam that is CO-Driven$/ do
  @course_offering.edit :final_exam_type => "Standard Final Exam", :final_exam_driver => "Final Exam Per Course Offering",
                        :use_final_exam_matrix => true
end

Given /^I create a Course Offering from catalog with No Exam that has an AO with RSI data found on the matrix in a term with a defined final exam period$/ do
  @course_offering = make CourseOffering, :term=> Rollover::PUBLISHED_EO_CREATE_TERM, :course => "ENGL304", :final_exam_type => "NONE"
  @course_offering.delivery_format_list[0].format = "Lecture"
  @course_offering.delivery_format_list[0].grade_format = "Lecture"

  @matrix = make FinalExamMatrix, :term_type => 'Spring Term'
  @matrix.create_standard_rule_matrix_object_for_rsi( "MWF")

  @course_offering.create

  @activity_offering = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject)
  end_time = (DateTime.strptime("#{@matrix.rules[0].statements[0].start_time}", '%I:%M') + ("50".to_f/1440)).strftime( '%I:%M')
  @course_offering.activity_offering_cluster_list[0].ao_list[0].add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
                                                     :days => @matrix.rules[0].statements[0].days,
                                                     :start_time => @matrix.rules[0].statements[0].start_time,
                                                     :start_time_ampm => @matrix.rules[0].statements[0].st_time_ampm,
                                                     :end_time => end_time, :end_time_ampm => @matrix.rules[0].statements[0].st_time_ampm)
end

When /^I edit the Course Offering to use a Standard Exam that is AO-Driven$/ do
  @course_offering.edit :final_exam_type => "Standard Final Exam", :final_exam_driver => "Final Exam Per Activity Offering",
                        :use_final_exam_matrix => true, :defer_save => true
  @course_offering.delivery_format_list[0].edit :final_exam_activity => "Lecture", :start_edit => false
end

Given /^I create a Course Offering from catalog with an Alternate Exam that has an AO with RSI data not found on the matrix in a term with a defined final exam period$/ do
  @matrix = make FinalExamMatrix, :term_type => 'Spring Term'
  @matrix.create_standard_rule_matrix_object_for_rsi( "F")

  @course_offering = create CourseOffering, :term=> Rollover::PUBLISHED_EO_CREATE_TERM, :course => "CHEM242", :final_exam_type => "ALTERNATE"

  @activity_offering = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lab/Lecture",
                                                                   :activity_type => "Lecture")
  end_time = (DateTime.strptime("#{@matrix.rules[0].statements[0].start_time}", '%I:%M') + ("50".to_f/1440)).strftime( '%I:%M')
  @course_offering.activity_offering_cluster_list[0].ao_list[0].add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
                                                     :days => @matrix.rules[0].statements[0].days,
                                                     :start_time => @matrix.rules[0].statements[0].start_time,
                                                     :start_time_ampm => @matrix.rules[0].statements[0].st_time_ampm,
                                                     :end_time => end_time, :end_time_ampm => @matrix.rules[0].statements[0].st_time_ampm)
end

Given /^I create a Course Offering from catalog with an Alternate Exam that has an AO with no RSI or ASI data$/ do
  @course_offering = make CourseOffering, :term => Rollover::PUBLISHED_EO_CREATE_TERM, :course => "ENGL250", :final_exam_type => "ALTERNATE"

  @course_offering.delivery_format_list[0].format = "Lecture"
  @course_offering.delivery_format_list[0].grade_format = "Lecture"
  @course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
  @course_offering.create

end


Given /^I create a Course Offering from catalog with No Exam that has an AO with no RSI or ASI data$/ do
  @course_offering = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "ENGL250", :final_exam_type => "NONE"

  @course_offering.delivery_format_list[0].format = "Lecture"
  @course_offering.delivery_format_list[0].grade_format = "Lecture"
  @course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
  @course_offering.create

end

Given /^I create a Course Offering from catalog with No Exam that has an AO with ASI data found on the matrix in a term with a defined final exam period$/ do
  @course_offering = make CourseOffering, :term=> Rollover::PUBLISHED_EO_CREATE_TERM, :course => "ENGL304", :final_exam_type => "NONE"
  @course_offering.delivery_format_list[0].format = "Lecture"
  @course_offering.delivery_format_list[0].grade_format = "Lecture"

  @matrix = make FinalExamMatrix, :term_type => 'Spring Term'
  @matrix.create_standard_rule_matrix_object_for_rsi( "TH")

  @course_offering.create

  @activity_offering = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject)
  @course_offering.activity_offering_cluster_list[0].ao_list[0].edit :send_to_scheduler => true

  end_time = (DateTime.strptime("#{@matrix.rules[0].statements[0].start_time}", '%I:%M') + ("50".to_f/1440)).strftime( '%I:%M')
  @course_offering.activity_offering_cluster_list[0].ao_list[0].add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
                                                     :days => @matrix.rules[0].statements[0].days,
                                                     :start_time => @matrix.rules[0].statements[0].start_time,
                                                     :start_time_ampm => @matrix.rules[0].statements[0].st_time_ampm,
                                                     :end_time => end_time, :end_time_ampm => @matrix.rules[0].statements[0].st_time_ampm)
end

Given /^I create a Course Offering from catalog with an Alternate Exam that has an AO with ASI data not found on the matrix in a term with a defined final exam period$/ do
  @matrix = make FinalExamMatrix, :term_typ => 'Spring Term'
  @matrix.create_standard_rule_matrix_object_for_rsi( "F")

  @course_offering = create CourseOffering, :term=> Rollover::PUBLISHED_EO_CREATE_TERM, :course => "CHEM242", :final_exam_type => "ALTERNATE"

  @activity_offering = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture/Lab",:activity_type => "Lecture")
  @course_offering.activity_offering_cluster_list[0].ao_list[0].edit :send_to_scheduler => true

  end_time = (DateTime.strptime("#{@matrix.rules[0].statements[0].start_time}", '%I:%M') + ("50".to_f/1440)).strftime( '%I:%M')
  @course_offering.activity_offering_cluster_list[0].ao_list[0].add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
                                                     :days => @matrix.rules[0].statements[0].days,
                                                     :start_time => @matrix.rules[0].statements[0].start_time,
                                                     :start_time_ampm => @matrix.rules[0].statements[0].st_time_ampm,
                                                     :end_time => end_time, :end_time_ampm => @matrix.rules[0].statements[0].st_time_ampm)
end

When /^I create multiple Course Offerings in the term$/ do
  @matrix = make FinalExamMatrix
  @matrix.create_common_rule_matrix_object_for_rsi( "ENGL313")
  @matrix.create_standard_rule_matrix_object_for_rsi( "MTH")
  @matrix.create_standard_rule_matrix_object_for_rsi( "WHF")
  th_end_time = (DateTime.strptime("#{@matrix.rules[1].statements[0].start_time}", '%I:%M') + ("50".to_f/1440)).strftime( '%I:%M')
  f_end_time = (DateTime.strptime("#{@matrix.rules[2].statements[0].start_time}", '%I:%M') + ("50".to_f/1440)).strftime( '%I:%M')

  @co_list = []
  course_offering = make CourseOffering, :term => @calendar.terms[0].term_code, :course => "ENGL313",
                         :final_exam_driver => "Final Exam Per Course Offering"
  course_offering.delivery_format_list[0].format = "Lecture"
  course_offering.delivery_format_list[0].grade_format = "Course Offering"
  @co_list << (course_offering.create)

  @co_list[0].create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture Only")

  course_offering = make CourseOffering, :term => @calendar.terms[0].term_code, :course => "ENGL362",
                         :final_exam_driver => "Final Exam Per Activity Offering"
  course_offering.delivery_format_list[0].format = "Lecture"
  course_offering.delivery_format_list[0].grade_format = "Course Offering"
  course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
  @co_list << (course_offering.create)

  @co_list[1].create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture Only")
  @co_list[1].activity_offering_cluster_list[0].ao_list[0].add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
                                                :days  => @matrix.rules[1].statements[0].days,
                                                :start_time  => @matrix.rules[1].statements[0].start_time,
                                                :start_time_ampm  => @matrix.rules[1].statements[0].st_time_ampm,
                                                :end_time  => th_end_time, :end_time_ampm  => @matrix.rules[1].statements[0].st_time_ampm)

  @co_list[1].create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture Only")
  @co_list[1].activity_offering_cluster_list[0].ao_list[1].add_req_sched_info :rsi_obj => (make SchedulingInformationObject,
                                                :days  => @matrix.rules[2].statements[0].days,
                                                :start_time  => @matrix.rules[2].statements[0].start_time,
                                                :start_time_ampm  => @matrix.rules[2].statements[0].st_time_ampm,
                                                :end_time  => f_end_time, :end_time_ampm  => @matrix.rules[2].statements[0].st_time_ampm)
end

When /^I initiate a rollover to create a term in open state$/ do
  @calendar_target = create AcademicCalendar, :year => @calendar.year.to_i + 1

  term_target = make AcademicTermObject, :parent_calendar => @calendar_target
  @calendar_target.add_term term_target

  exam_period = make ExamPeriodObject, :parent_term => term_target
  @calendar_target.terms[0].add_exam_period exam_period
  @calendar_target.terms[0].save

  @calendar_target.terms[0].make_official

  @rollover = make Rollover, :target_term => @calendar_target.terms[0].term_code ,
                   :source_term => @calendar.terms[0].term_code#,
                   #:exp_success => false
  @rollover.perform_rollover
  @rollover.wait_for_rollover_to_complete
  @rollover.release_to_depts
  @manage_soc = make ManageSoc, :term_code => @calendar_target.terms[0].term_code
  @manage_soc.create_exam_offerings_soc
end

When /^I create Exam Matrix rules from which the Exam Offering Slotting info is populated$/ do
  @matrix.rules.each do |rule|
    rule.parent_exam_matrix = @matrix
    rule.create
  end
end

Then /^the Exam Offerings Slotting info should be populated after the Mass Scheduling Event has been triggered$/ do
  @co_list.each do |co|
    test_co = make CourseOffering, :term => @calendar_target.terms[0].term_code, :course => co.course
    test_co.initialize_with_actual_values
    on(ManageCourseOfferings).view_exam_offerings
    if test_co.course != @co_list[0].course
      on ViewExamOfferings do |page|
        ao = test_co.activity_offering_cluster_list[0].ao_list[0]
        page.ao_eo_days(ao.code).should match /#{@matrix.rules[1].rsi_days}/
        page.ao_eo_st_time(ao.code).should match /#{@matrix.rules[1].start_time}/i
        page.ao_eo_end_time(ao.code).should match /#{@matrix.rules[1].end_time}/i

        ao = test_co.activity_offering_cluster_list[0].ao_list[1]
        page.ao_eo_days(ao.code).should match /#{@matrix.rules[2].rsi_days}/
        page.ao_eo_st_time(ao.code).should match /#{@matrix.rules[2].start_time}/i
        page.ao_eo_end_time(ao.code).should match /#{@matrix.rules[2].end_time}/i
      end
    else
      on ViewExamOfferings do |page|
        page.co_eo_days.should match /#{@matrix.rules[0].rsi_days}/
        page.co_eo_st_time.should match /#{@matrix.rules[0].start_time}/i
        page.co_eo_end_time.should match /#{@matrix.rules[0].end_time}/i
      end
    end
  end
end

When /^I? select matrix override and add facility and room information to the exam offering RSI$/ do
  @eo_rsi.edit :do_navigation => false,
               :day => 'Day 5',
               :start_time => '12:00 PM',
               :end_time => '1:50 PM',
               :facility => 'VMH',
               :room => '1212',
               :override_matrix => true
end

Given /^I set up an academic term for exam offering creation in open SOC state$/ do
  @calendar = make AcademicCalendar, :year => Rollover::OPEN_EO_CREATE_TERM[0..3]
  term = make AcademicTermObject, :parent_calendar => @calendar, :term => 'Spring', :term_code => Rollover::OPEN_EO_CREATE_TERM
  @calendar.terms << term
  @calendar.terms[0].exam_period = make ExamPeriodObject, :parent_term => term, :start_date=>"05/11/#{Rollover::OPEN_EO_CREATE_TERM[0..3]}",
                                        :end_date=>"05/18/#{Rollover::OPEN_EO_CREATE_TERM[0..3]}"

  @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
  @manage_soc.set_up_soc
  @manage_soc.perform_manual_soc_state_change
end

Given /^I set up an academic term for exam offering creation in published SOC state$/ do
  @calendar = make AcademicCalendar, :year => Rollover::PUBLISHED_EO_CREATE_TERM[0..3]
  term = make AcademicTermObject, :parent_calendar => @calendar, :term => 'Spring', :term_code => Rollover::PUBLISHED_EO_CREATE_TERM
  @calendar.terms << term
  @calendar.terms[0].exam_period = make ExamPeriodObject, :parent_term => term, :start_date=>"05/11/#{Rollover::PUBLISHED_EO_CREATE_TERM[0..3]}",
                                        :end_date=>"05/18/#{Rollover::PUBLISHED_EO_CREATE_TERM[0..3]}"

  @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
  @manage_soc.set_up_soc
  @manage_soc.perform_manual_soc_state_change
  @manage_soc.advance_soc_from_open_to_published
end


Given /^a new academic term has courses found in the CO based exam matrix$/ do
  @calendar = create AcademicCalendar #, :year => "2235", :name => "fSZtG62zfU"
  term = make AcademicTermObject, :parent_calendar => @calendar
  @calendar.add_term term

  exam_period = make ExamPeriodObject, :parent_term => term, :start_date=>"12/11/#{@calendar.year}",
                     :end_date=>"12/20/#{@calendar.year}"
  @calendar.terms[0].add_exam_period exam_period
  @calendar.terms[0].save

  @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
  @manage_soc.set_up_soc
  @manage_soc.perform_manual_soc_state_change

  @course_offering = make CourseOffering, :term=> @calendar.terms[0].term_code,
                          :course => "ENGL407"
  @course_offering.delivery_format_list[0].format = "Lecture"
  @course_offering.delivery_format_list[0].grade_format = "Lecture"
  @course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
  @course_offering.create

  @activity_offering = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                              :format => "Lecture Only", :activity_type => "Lecture"
  @activity_offering.approve :navigate_to_page => false

  @matrix = make FinalExamMatrix, :term_type => "Fall Term"
  @matrix.create_common_rule_matrix_object_for_rsi( @course_offering.course[0..6]) #canonical course code only
end

Given /^an academic term has course offerings with slotted exam offerings$/ do
  @calendar = make AcademicCalendar, :year => '2020', :name => '2019-2020 Academic Calendar'
  term = make AcademicTermObject, :parent_calendar => @calendar, :term => 'Spring', :term_code => '202001'
  @calendar.terms << term
  @calendar.terms[0].exam_period = make ExamPeriodObject, :parent_term => term, :start_date=>"05/11/2020",
                     :end_date=>"05/18/2020"

  @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
  @manage_soc.set_up_soc
  @manage_soc.perform_manual_soc_state_change

  @course_offering = make CourseOffering, :term=> @calendar.terms[0].term_code,
                          :course => 'CHEM131', :suffix => ' '
  @course_offering.delivery_format_list[0].format = 'Lecture'
  @course_offering.delivery_format_list[0].grade_format = 'Lecture'
  @course_offering.delivery_format_list[0].final_exam_activity = 'Lecture'
  @course_offering.create

  @activity_offering = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                              :format => 'Lecture Only', :activity_type => 'Lecture'
  @activity_offering.approve :navigate_to_page => false

  @matrix = make FinalExamMatrix, :term_type => "Spring Term"
  @matrix.create_common_rule_matrix_object_for_rsi( @course_offering.course[0..6]) #canonical course code only

  @course_offering1 = make CourseOffering, :term => "202001",
                           :course => "HIST110",
                           :final_exam_driver => "Final Exam Per Activity Offering",
                           :suffix => ' '
  @course_offering1.delivery_format_list[0].format = 'Lecture'
  @course_offering1.delivery_format_list[0].grade_format = 'Lecture'
  @course_offering1.delivery_format_list[0].final_exam_activity = 'Lecture'

  @matrix.create_standard_rule_matrix_object_for_rsi( "MWF at 03:00 PM")

  @course_offering1.create
  @activity_offering1 = @course_offering1.create_ao :ao_obj => (make ActivityOfferingObject)
  si_obj =  make SchedulingInformationObject, :days => "MWF",
                 :start_time => "03:00", :start_time_ampm => "pm",
                 :end_time => "03:50", :end_time_ampm => "pm"
  @activity_offering1.add_req_sched_info :rsi_obj => si_obj

  @eo_rsi = make EoRsiObject, :ao_driven => true, :ao_code => @activity_offering.code,
                 :day => @matrix.rules[0].rsi_days,
                 :start_time => "#{@matrix.rules[0].start_time} #{@matrix.rules[0].st_time_ampm}",
                 :end_time => "#{@matrix.rules[0].end_time} #{@matrix.rules[0].end_time_ampm}",
                 :facility =>si_obj.facility, #use AO location is checked on matrix page
                 :room => si_obj.room         #use AO location is checked on matrix page


end

Given(/^I manage an AO\-driven exam offering$/) do
  @course_offering = make CourseOffering, :term=> '201208',
                          :course => 'ENGL304'
  @activity_offering = make ActivityOfferingObject, :code=>'A', :parent_cluster=>@course_offering.default_cluster
  @course_offering.manage

  @eo_rsi = make EoRsiObject, :ao_code => @activity_offering.code,
                 :ao_driver_activity => 'Lecture',
                 :day => 'Day 1',
                 :start_time => '08:00 AM',
                 :end_time => '10:00 AM',
                 :facility => 'Tawes Fine Arts Bldg.',
                 :room => '1100'

  on(ManageCourseOfferings).view_exam_offerings
end

Given(/^I manage a CO\-driven exam offering$/) do
  @course_offering = make CourseOffering, :term=> '201208',
                          :course => 'CHEM135'
  @course_offering.manage

  @eo_rsi = make EoRsiObject, :day => 'Day 2',
                 :start_time => '10:30 AM',
                 :end_time => '12:30 PM',
                 :facility => 'Jull "Hall"',
                 :room => '1105'

  on(ManageCourseOfferings).view_exam_offerings
end