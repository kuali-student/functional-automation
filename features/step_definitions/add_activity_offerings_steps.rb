When /^I manage an existing Course Offering in Course Offering Code view$/ do
  @course_offering = make CourseOffering, :course=>"CHEM317"
  @course_offering.manage
end

When /^I manage an existing Course Offering in Subject Code view$/ do
  @course_offering = make CourseOffering, :course=>"CHEM"
  @course_offering.manage
  on ManageCourseOfferingList do |page|
    co_code = page.co_list[0]
    page.manage(co_code)
  end
end

Then /^I am able to add an Activity Offering$/ do
  on ManageCourseOfferings do |page|
    $total_number = page.codes_list.count
    format = page.format.options[1].text
    page.add_ao format, 1
  end
end

Then /^I am able to copy an Activity Offering$/ do
  on ManageCourseOfferings do |page|
    $total_number = page.codes_list.count
    ao_code = page.codes_list[0]
    page.copy(ao_code)
  end
end

And /^verify the new Activity Offering appears on the list$/ do
  on ManageCourseOfferings do |page|
    new_total = page.codes_list.count
    new_total.should == $total_number + 1
  end
end





