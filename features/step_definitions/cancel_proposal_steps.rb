Given(/^I have a proposal submitted as Faculty$/) do
  steps %{Given I am logged in as Faculty}

  subject_code = "BMGT"
  course_number = course_number_generator(subject_code)

  @course_proposal = create CmCourseProposalObject, :create_new_proposal => true,
                            :submit_fields => [(make CmSubmitFieldsObject, :subject_code => subject_code)],
                            :approve_fields => [(make CmApproveFieldsObject, :course_number => course_number)]


  puts @course_proposal.proposal_title
  @course_proposal.submit_proposal
end

When(/^I Withdraw the Proposal$/) do
  @course_proposal.withdraw_proposal
end

Then(/^can see the proposal has been Withdrawn$/) do
  return_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
  on CmReviewProposalPage do |proposal|
    proposal.proposal_status.should include "withdrawn"
  end
end


Given(/^I have a proposal blanket approved by Curriculum Specialist$/) do
  pending # express the regexp above with the code you wish you had
end


Then(/^I cannot cancel the proposal as (.*?)$/) do  |faculty|
  log_in faculty,faculty
  navigate_rice_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
  on CmReviewProposalPage do |page|
    begin
      page.withdraw_button.exists?.should be_false
    rescue
      # rescue means that the button was not found
    end
  end

end


And(/^I have a basic credit course proposal created$/) do
  @course_proposal = create CmCourseProposalObject, :create_new_proposal => false, :create_basic_propsal => true,
                            :proposal_title => random_alphanums(10,'test basic proposal title '),
                            :course_title => random_alphanums(10,'test basic course title ')
  @course_proposal.create_course_continue
  @course_proposal.create_basic_proposal
end


When(/^I Cancel Proposal$/) do
  @course_proposal.cancel_proposal_document
end


Then(/^can see the proposal has been cancelled$/) do
  return_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
  on CmReviewProposalPage do |proposal|
    proposal.proposal_status.should include "cancelled"
  end
end


Given(/^I have a credit course proposal submitted as Faculty$/) do
  steps %{Given I have a proposal submitted as Faculty}
end

Then(/^I cannot cancel the proposal$/) do
  return_to_cm_home
  @course_proposal.search
  @course_proposal.review_proposal_action
  on CmReviewProposalPage do |proposal|
    begin
      proposal.cancel_proposal_button.exists?.should be_false
    rescue
      #means the button was not found
    end
  end

end