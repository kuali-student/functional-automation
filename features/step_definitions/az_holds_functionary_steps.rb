When(/^I apply a hold to a student by completing the required information$/) do
  @applied_hold = create AppliedHold, :student_id => "KS-2067", :hold_issue => (make HoldIssue, :code => "ACAD04")
  @applied_hold.apply_hold
end

When /^I attempt to apply a hold to a student$/ do
  @applied_hold = create AppliedHold, :student_id => "KS-2077", :hold_issue => (make HoldIssue, :code => "ACAD04")
  @applied_hold.apply_hold
end

And(/^I edit a hold to add an expiration date to a student record$/) do
  hold_issue = make HoldIssue, :code => "ACAD05", :first_term => "201208", :term_based => true
  @applied_hold = create AppliedHold, :student_id => "KS-1675", :find_code_by_lookup => true, :hold_issue => hold_issue
  @applied_hold.apply_hold

  @applied_hold.expire_hold :expiration_date => right_now[:date_w_slashes], :expiration_term => "201401"
end

And(/^I find a hold$/) do
  hold_issue = make HoldIssue, :code => "ACAD02"
  @applied_hold = create AppliedHold, :student_id=> "KS-1675", :hold_issue => hold_issue
end

Then /^an expire hold authorization error message is displayed$/ do
  on(ManageAppliedHold).get_validation_message.should match /#{@applied_hold.hold_issue.code} will not be expired as you don't have authorization to expire this hold/
end

When(/^I attempt to expire that hold$/) do
  on ManageAppliedHold do |page|
    page.select_hold( @applied_hold.hold_issue.code)
    page.expire_hold
  end
end

Then(/^the expired hold is no longer displayed for the student$/) do
  on(ManageAppliedHold).get_active_applied_hold_by_code(@applied_hold.hold_issue.code).nil?.should be_true
end

And(/^I delete a hold on a student record$/) do
  @applied_hold = create AppliedHold, :student_id => "KS-2068", :hold_issue => (make HoldIssue, :code => "ACAD02")
  @applied_hold.apply_hold

  @applied_hold.delete_hold
end

Then(/^the deleted hold no longer displays for the student$/) do
  on(ManageAppliedHold).get_active_applied_hold_by_code(@applied_hold.hold_issue.code).nil?.should be_true
end

Then /^a delete hold authorization error message is displayed$/ do
  on(ManageAppliedHold).get_validation_message.should match /#{@applied_hold.hold_issue.code} will not be deleted as you don't have authorization to delete this hold/
end

When(/^I attempt to delete that hold$/) do
  on ManageAppliedHold do |page|
    page.select_hold( @applied_hold.hold_issue.code)
    page.delete_hold
  end
end

Then /^an apply hold authorization error message is displayed$/ do
  on(ApplyHold).get_validation_message.should match /Not authorized to apply hold/
end




