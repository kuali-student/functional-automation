When /^I create a Course Offering with a lecture Delivery Format$/ do
  @course_offering = make CourseOffering, :term=> Rollover::OPEN_SOC_TERM, :course => "ENGL222", :final_exam_driver => 'Final Exam Per Activity Offering'
  @course_offering.delivery_format_list[0].format = "Lecture"
  @course_offering.delivery_format_list[0].grade_format = "Course Offering"
  @course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
  @course_offering.create

  @course_offering.create_ao :navigate_to_page => false
end

When /^I create a Course Offering with two Delivery Formats$/ do
  @course_offering = make CourseOffering, :term=> Rollover::OPEN_SOC_TERM, :course => "ENGL222", :final_exam_driver => 'Final Exam Per Activity Offering'
  @course_offering.delivery_format_list[0].format = "Lecture"
  @course_offering.delivery_format_list[0].grade_format = "Course Offering"
  @course_offering.delivery_format_list[0].final_exam_activity = "Lecture"

  @course_offering.delivery_format_list << (make DeliveryFormatObject,
                                                 :format => "Discussion/Lecture",
                                                 :grade_format => "Lecture",
                                                 :final_exam_activity => "Lecture",
                                                 :parent_co => @course_offering)
  @course_offering.create
  @course_offering.create_ao :navigate_to_page => false
end

And /^I create a Course Offering with random Delivery Formats$/ do
  @course_offering = create CourseOffering, :term=> Rollover::MAIN_TEST_TERM_TARGET, :final_exam_driver => 'Final Exam Per Activity Offering'
end

Then /^the new Course Offering should contain only the selected delivery formats$/ do
  @course_offering.view_course_details
  on CourseOfferingInquiry do  |page|
    @course_offering.delivery_format_list.each do |del_option|
      page.get_grade_roster_level(del_option.format).should == del_option.grade_format
      page.get_final_exam_activity(del_option.format).should == del_option.final_exam_activity
    end
    page.close
  end
end

And /^I create a course offering from an existing offering$/ do
  @course_offering = (make CourseOffering, :term=> "201201", :course => "CHEM132").create_from_existing :target_term=> Rollover::PUBLISHED_SOC_TERM
end

When /^I create a course offering from an existing offering in a different term and choose to exclude instructor information$/ do
  @course_offering = (make CourseOffering, :term=> Rollover::MAIN_TEST_TERM_SOURCE, :course => "CHEM132").create_from_existing :target_term=> Rollover::FINAL_EDITS_SOC_TERM, :exclude_instructor => true
end

When /^I create a course offering from an existing offering in a different term and choose to exclude scheduling information$/ do
  @course_offering = (make CourseOffering, :term=> Rollover::MAIN_TEST_TERM_SOURCE, :course => "CHEM132").create_from_existing :target_term=> Rollover::FINAL_EDITS_SOC_TERM, :exclude_scheduling => true
end

When /^I create a course offering from an existing offering within same term and choose to exclude scheduling information$/ do
  @course_offering = (make CourseOffering, :term=> Rollover::PUBLISHED_SOC_TERM, :course => "ENGL295").create_from_existing :target_term=> Rollover::PUBLISHED_SOC_TERM, :course => "ENGL295", :exclude_scheduling => true
end

When /^I create a course offering from an existing offering within same term and choose to exclude instructor information using Create CO$/ do
  @course_offering = (make CourseOffering, :term=> Rollover::PUBLISHED_SOC_TERM, :course => "ENGL295").create_from_existing :target_term=> Rollover::PUBLISHED_SOC_TERM, :course => "ENGL295", :exclude_instructor => true
end

When /^I create a course offering from an existing offering within same term and choose to exclude instructor information using Manage CO$/ do
  @course_offering = (make CourseOffering, :course => "CHEM132", :term=> Rollover::MAIN_TEST_TERM_SOURCE).copy :exclude_instructor => true
end

Then /^the new Course Offering should be displayed in the list of available offerings$/ do
  @course_offering.view_course_details
  on CourseOfferingInquiry do |page|
    page.close
  end
end

And /^the new Course Offering should not contain any instructor information in its activity offerings$/ do
  @course_offering.manage
  on ManageCourseOfferings do |page|
    page.get_instructor_list.should == ""
  end
end

And /^the new Course Offering should not contain any scheduling information in its activity offerings$/ do
  @course_offering.manage
    ao_list = @course_offering.get_ao_list
    ao_list.each do |ao_code|
      on(ManageCourseOfferings).view_activity_offering(ao_code.code)
      on ActivityOfferingInquiry do |page2|
        page2.requested_scheduling_information_days.present?.should be_false
        page2.actual_scheduling_information_days.present?.should be_false
        page2.close
      end
  end
end

And /^I create a Course Offering from catalog with Activity Offerings assigned to subterms$/ do
  @course_offering = make CourseOffering, :term=> @calendar.terms[0].term_code,
                            :course => "CHEM132"
  @course_offering.delivery_format_list[0].format = "Lab"
  @course_offering.delivery_format_list[0].grade_format = "Lab"
  @course_offering.delivery_format_list[0].final_exam_activity = "Lab"
  @course_offering.create

  @activity_offering = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                              :format => "Lab Only", :activity_type => "Lab"
  @activity_offering.edit :subterm => @calendar.terms[0].subterms[0].subterm_type, :defer_save => true
  @activity_offering.add_req_sched_info :rsi_obj => (make SchedulingInformationObject, :days => "MT"), :start_edit => false

  @activity_offering2 = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                               :format => "Lab Only", :activity_type => "Lab"
  @activity_offering2.edit :subterm => @calendar.terms[0].subterms[1].subterm_type, :defer_save => true
  @activity_offering2.add_req_sched_info :rsi_obj => (make SchedulingInformationObject, :days => "WF"), :start_edit => false
end

And /^I create a Course Offering with an Activity Offerings assigned to subterms$/ do
  step 'I create a Course Offering from catalog with Activity Offerings assigned to subterms in my admin org'
end

And /^I create a Course Offering from catalog with Activity Offerings assigned to subterms in my admin org$/ do
  @course_offering = make CourseOffering, :term=> @calendar.terms[0].term_code,
                            :course => "ENGL211"
  @course_offering.delivery_format_list[0].format = "Lecture"
  @course_offering.delivery_format_list[0].grade_format = "Lecture"
  @course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
  @course_offering.create

  @activity_offering = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                              :format => "Lecture Only", :activity_type => "Lecture"
  @activity_offering.edit :subterm => @calendar.terms[0].subterms[0].subterm_type, :defer_save => true
  @activity_offering.add_req_sched_info :rsi_obj => (make SchedulingInformationObject, :days => "MT"), :start_edit => false

  @activity_offering2 = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                               :format => "Lecture Only", :activity_type => "Lecture"
  @activity_offering2.edit :subterm => @calendar.terms[0].subterms[1].subterm_type, :defer_save => true
  @activity_offering2.add_req_sched_info :rsi_obj => (make SchedulingInformationObject, :days => "WF"), :start_edit => false
end

And /^I create a Course Offering from catalog with Activity Offerings$/ do
  @course_offering = make CourseOffering, :term=> @calendar.terms[0].term_code,
                            :course => "CHEM132"
  @course_offering.delivery_format_list[0].format = "Lab"
  @course_offering.delivery_format_list[0].grade_format = "Lab"
  @course_offering.delivery_format_list[0].final_exam_activity = "Lab"
  @course_offering.create

  @activity_offering = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                              :format => "Lab Only", :activity_type => "Lab"
  @activity_offering.add_req_sched_info :rsi_obj => (make SchedulingInformationObject, :days => "MT")

  @activity_offering2 = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                               :format => "Lab Only", :activity_type => "Lab"
  @activity_offering2.add_req_sched_info :rsi_obj => (make SchedulingInformationObject, :days => "WF")
end


Given(/^I have an existing course offering with cancelled activity offerings$/) do
  @orig_course_offering = make CourseOffering, :term=> '201208', :course => "CHEM483"

  @orig_course_offering.manage
  on ManageCourseOfferings do |page|
    page.ao_status('I').should == ActivityOfferingObject::CANCELED_STATUS
    page.ao_status('K').should == ActivityOfferingObject::CANCELED_STATUS
  end
end

When(/^I create a course offering in a different term from the existing offering and choose to exclude cancelled activity offerings$/) do
  @course_offering = @orig_course_offering.create_from_existing :target_term=> Rollover::MAIN_TEST_TERM_TARGET, :exclude_cancelled_aos => true
end

Then(/^the new Course Offering should not contain cancelled activity offerings$/) do
  on ManageCourseOfferings do |page|
    actual_ao_codes = page.codes_list
    actual_ao_codes.should_not include 'K'
    actual_ao_codes.should_not include 'I'
  end
end

When(/^I copy the existing offering to create a course in the same term and choose to exclude cancelled activity offerings$/) do
  @course_offering = (@orig_course_offering).copy :exclude_cancelled_aos => true
end