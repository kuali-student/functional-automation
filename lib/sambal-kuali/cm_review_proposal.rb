class CmReviewProposalPage < BasePage

  wrapper_elements
  cm_elements

  action(:submit) { |b| b.button(text: 'Submit').click; b.loading_wait }
  action(:edit_course_information) { |b| b.a(id: "CM-Proposal-Review-CourseInfo-Edit-Link").click }
  element(:review_proposal_header) { |b| b.div(id: "CM-Proposal-Course-Create-Header").p(class: "uif-viewHeader-supportTitle").text }
  element(:review_proposal_title_header) { |b| b.header(id: "CM-Proposal-Course-Create-Header").span(class: "uif-headerText-span").text }

  # COURSE INFORMATION REVIEW FIELDS
  element(:proposal_title_element) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Proposal-Name_control") }
  value(:proposal_title_review) { |b| b.proposal_title_element.text }
  value(:transcript_course_title) { |b| b.textarea(name: /transcriptTitle/).text}
  element(:transcript_course_title_error) { |b| b.div(data_label: "Transcript Course Title", class: /hasError/ ) }
  value(:course_title_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Course-Title_control").text }
  value(:subject_code_review) { |b| b.textarea(id:"CM-ViewCourseView-CourseInfo-Subject-Area_control").text }
  value(:course_number_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-CourseNumberSuffix_control").text }
  element(:course_number_review_error_state) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-CourseNumberSuffix", class: /hasError/) }
  value(:cross_listed_courses_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-CrossListings_control").text }
  value(:jointly_offered_courses_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-JointlyOfferedCourses_control").text }
  value(:version_codes_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Version-Codes_control" ).text}
  value(:instructors_review) { |b| b.textarea(id: 'CM-ViewCourseView-CourseInfo-Instructors_control').text }
  value(:description_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Descr_control").text }
  value(:proposal_rationale_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Rationale_control").text }



  # COURSE INFORMATION READ-ONLY REVIEW FIELDS
  value(:proposal_title_review_read_only) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-Proposal-Name").text }
  value(:course_title_review_read_only) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-Course-Title").text }


  # GOVERNANCE REVIEW FIELDS
  action(:edit_governance) { |b| b.a(id: "CM-ViewCourseView-Logistics-Edit-Link").click }
  value(:campus_locations_review) { |b| b.textarea(id: 'CM-ViewCourseView-Governance-CampusLocations_control').text }
  element(:campus_locations_error) { |b| b.div(id:"CM-ViewCourseView-Governance-CampusLocations", class: /hasError/) }
  value(:curriculum_oversight_review) { |b| b.textarea(id: 'CM-ViewCourseView-Governance-CurriculumOversight_control').text }
  element(:curriculum_oversight_error_state) { |b| b.textarea(id: "CM-ViewCourseView-Governance-CurriculumOversight", class: /hasError/) }
  value(:administering_org_review) { |b| b.textarea(id: 'CM-ViewCourseView-Governance-AdministeringOrganization_control').text }


  # LOGISTICS REVIEW FIELDS
  action(:edit_course_logistics) { |b| b.a(id: "CourseLogistics-Review-Edit-link").click }
  value(:terms_review) { |b| b.textarea(id: 'CM-ViewCourseView-Logistics-Terms_control').text }
  value(:duration_review) { |b| b.textarea(id: 'CM-ViewCourseView-Logistics-DurationType_control').text }
  value (:audit_review) { |b| b.textarea(id: 'CM-ViewCourseView-Logistics-Audit_control').text }
  value(:pass_fail_transcript_review) { |b| b.textarea(id: 'CM-ViewCourseView-Logistics-PassFail_control').text }


  value(:assessment_scale_review) { |b| b.textarea(id: "CM-ViewCourseView-Logistics-GradingOptions_control").text }
  value(:final_exam_status_review) { |b| b.textarea(id: "CM-ViewCourseView-Logistics-FinalExamStatus_control").text }
  value(:final_exam_rationale_review) { |b| b.textarea(id: "CM-ViewCourseView-Logistics-FinalExamRationale_control").text }

  value(:outcome_level_review) { |outcome_level,b| b.div(id: "CM-ViewCourseView-Outcome-Details").header(id: /line#{outcome_level-1}/).span(class: "uif-headerText-span").text }
  value(:outcome_type_review) { |outcome_level,b| b.div(id: "CM-ViewCourseView-Outcome-Details").div(id: /line#{outcome_level-1}/, data_label: "Type").text }
  value(:outcome_credit_review) { |outcome_level,b| b.div(id: "CM-ViewCourseView-Outcome-Details").div(id: /line#{outcome_level-1}/, data_label: "Credit Value").text }
  element(:outcome_error_state) { |b| b.div(data_label: "Outcomes", class: /hasError/) }

  element(:outcome_empty_text) { |b| b.textarea(name: /.*courseLogisticsSection.emptyStringOutcomes/) }

  #LEARNING OBJECTIVES
  value(:lo_terms_review) { |lo_review,b| b.textarea(id: "learningObjectivesSection_learningObjectives_line#{lo_review-1}_control").text }
  value(:learning_objectives_summary_review) { |b| b.div(id: "course_review_learning_objectives").text }
  value(:learning_objectives_review) { |lo_level,b| b.div(id: "CM-ViewCourseView-LearningObjectives-Item_line#{lo_level-1}").text }
  element(:learning_objectives_empty_text) { |b| b.div(id: "emptyStringLOs") }

  #COURSE REQUISITES
  #Student Eligibility & Prerequisite
  value(:prerequisites_operators_and_rules) {|b|b.div(id: "CM-Proposal-Course-AgendaManage-ViewRule_ruleA").text }
  value(:prerequisites_rule) {|line, b|b.div(:id => /CM-Proposal-Course-ListItems-DataGroup_node#{line}_node0_root/).text }
  value(:prerequisites_operator) {|index, b|b.div(:id => /CM-Proposal-Course-ListItems-DataGroup_node#{index}_node0_root/).text }
  #Corequisite
  value(:corequisite_operators_and_rules) {|b|b.div(id: "CM-Proposal-Course-AgendaManage-ViewRule_ruleB").text }

  #Recommended Preparation
  value(:preparation_operators_and_rules) {|b|b.div(id: "CM-Proposal-Course-AgendaManage-ViewRule_ruleC").text }

  #Antirequisite
  value(:antirequisite_operators_and_rules) {|b|b.div(id: "CM-Proposal-Course-AgendaManage-ViewRule_ruleD").text }

  #Repeatable for Credit
  value(:repeatableForCredit_operators_and_rules) {|b|b.div(id: "CM-Proposal-Course-AgendaManage-ViewRule_ruleE").text }

  #Course that Restricts Credits
  value(:restrictsCredits_operators_and_rules) {|b|b.div(id: "CM-Proposal-Course-AgendaManage-ViewRule_ruleF").text }

  #ACTIVITY FORMATS
  element(:activity_format_review_section) { |b| b.div(id:"CM-ViewCourseView-Format-Details") }
  value(:format_level_review) { |format_level, b| b.activity_format_review_section.section(id: /line#{format_level-1}$/,data_parent: "CM-ViewCourseView-Format-Details").header(id: /line#{format_level-1}$/).span(class: "uif-headerText-span").text }
  value(:activity_level_review) { |format_level,activity_level, b| b.activity_format_review_section.section(id:/line#{format_level-1}_line#{activity_level-1}$/).header(id: /line#{format_level-1}_line#{activity_level-1}$/).span(class: "uif-headerText-span").text }
  value(:activity_type_review)  { |format_level,activity_level, b| b.activity_format_review_section.section(id:/line#{format_level-1}_line#{activity_level-1}$/).header(id: /line#{format_level-1}_line#{activity_level-1}$/).span(class: "uif-headerText-span").text }
  value(:activity_contact_hours_frequency_review) { |format_level,activity_level, b| b.activity_format_review_section.textarea(id: /activity_contactHours.*\_line#{format_level-1}_line#{activity_level-1}_control/).text }
  value(:activity_duration_type_count_review) { |format_level,activity_level, b| b.activity_format_review_section.textarea(id: /activity_durationCount.*\_line#{format_level-1}_line#{activity_level-1}_control/).text }
  value(:activity_class_size_review) { |format_level,activity_level, b| b.activity_format_review_section.textarea(id: /activity_anticipatedClassSize.*\_line#{format_level-1}_line#{activity_level-1}_control/).text }
  element(:activity_format_error) { |b|b.div(id: "emptyStringFormats", class: /hasError/) }
  element(:activities_in_format_section)  { |format_level, b| b.activity_format_review_section.section(id: /line#{format_level-1}$/,data_parent: "CM-ViewCourseView-Format-Details") }

  # ACTIVE DATES REVIEW FIELDS
  action(:edit_active_dates) { |b| b.a(id: 'ActiveDates-Review-Edit-link').click }
  value(:start_term_review) { |b| b.textarea(id: "CM-ViewCourseView-ActiveDates-StartTerm_control").text }
  value(:end_term_review) { |b| b.textarea(id: 'CM-ViewCourseView-ActiveDates-EndTerm_control').text }
  value(:pilot_course_review) { |b| b.textarea(id: 'CM-ViewCourseView-ActiveDates-PilotCourse_control').text }

  # FINANCIAL FEES
  value(:fee_justification_review ) { |b| b.textarea(id: "CM-Proposal-Review-Financials-FeeJustification_control").text }

  #AUTHORS & COLLABORATORS
  value(:author_name_review) { |author_level,b| b.div(id: "CM-Proposal-Review-AuthorsCollaborators-Section").header(id: /line#{author_level-1}/).span(class: "uif-headerText-span").text }
  value(:author_permission_review) { |author_level,b| b.div(id: "CM-Proposal-Review-AuthorsCollaborators-Section").section(id: /line#{author_level-1}/).div(data_label: "Permissions").textarea(name: /permission/).text  }
  value(:action_request_review) { |author_level,b| b.div(id: "CM-Proposal-Review-AuthorsCollaborators-Section").section(id: /line#{author_level-1}/).div(data_label: "Action Request").textarea(name: /action/).text }
  element(:empty_authors_collab_review) { |b| b.textarea(id: "emptyStringAuthorsAndCollaborators_control") }

  #SUPPORTING DOCS
  value(:supporting_docs_review) { |b| b.div(id: "CM-Proposal-Review-SupportingDocuments-Section").text }
  element(:empty_supporting_docs_review) { |b| b.textarea(id: " ")}

  #SUBMITCmReviewProposal
  element(:submit_button) { |b| b.button(text: "Submit")}
  element(:submit_button_disabled) { |b| b.button(text: "Submit", class: /disabled/) }
  action(:submit_proposal) { |b| b.button(text: "Submit").click; b.loading_wait }
  action(:submit_confirmation) { |b| b.div(class: "fancybox-outer").span(class: "ui-button-text", text: "Submit").click; b.loading_extended_wait }
  element(:proposal_status_element) { |b| b.div(id: "CM-Proposal-Header-Right-Group-Status").p(id: /CM-Proposal-Status/) }
  value(:proposal_status) { |b| b.proposal_status_element.text.downcase }

  #APPROVE
  element(:approve_button) { |b| b.button(text: "Approve") }
  element(:approve_button_disabled) { |b| b.button(text: "Approve", class: /disabled/) }
  action(:review_approval) { |b| b.approve_button.click; b.loading_wait }
  element(:decision_rationale) { |b| b.div(class: "fancybox-inner").textarea(id: "CM-Approve-Dialog-Explanation_control") }
  element(:blanket_approve_rationale) { |b| b.div(class: "fancybox-inner").textarea(id: "CM-BlanketApprove-Dialog-Explanation_control") }
  element(:return_rationale) { |b| b.div(class: "fancybox-inner").textarea(id: "CM-ReturnToPrevious-Dialog-Explanation_control") }
  action(:confirmation_approval) { |b| b.div(class: "fancybox-inner").span(class: "ui-button-text", text: "Approve").click; b.loading_extended_wait }
  element(:blanket_approve_button) { |b| b.button(text: "Blanket Approve") }
  element(:blanket_approve_disabled) { |b| b.button(text: "Blanket Approve", class: /disabled/)}
  action(:blanket_approve) { |b| b.blanket_approve_button.click; b.loading_wait }
  element(:resubmit_button) { |b| b.button(text: "Resubmit") }
  action(:resubmit) { |b| b.resubmit_button.click; b.loading_wait}
  element(:review_button) { |b| b.button(text: "Return to Previous") }
  action(:review_return) { |b| b.review_button.click; b.loading_wait  }
  action(:confirm_return) { |b| b.div(class: "fancybox-inner").span(class: "ui-button-text", text: "Return").click }
  element(:return_to_node_list) { |b| b.div(class: "fancybox-inner").select_list(id: "CM-ReturnToPrevious-Dialog-NodeNamesDropdown_control") }
  element(:fyi_button) { |b| b.button(text: "FYI") }
  action(:fyi_review) { |b| b.fyi_button.click; b.loading_wait }
  element(:acknowledge_button) { |b| b.button(text: "Acknowledge") }
  action(:acknowledge) { |b| b.acknowledge_button.click; b.loading_wait }
  action(:confirmation_acknowledge) { |b| b.div(class: "fancybox-inner").span(class: "ui-button-text", text: "Acknowledge").click; b.loading_wait }
  element(:acknowledge_rationale) { |b| b.div(class: "fancybox-inner").textarea(id: "CM-Acknowledge-Dialog-Explanation_control") }
  element(:reject_button) {|b| b.button(text: "Reject")}
  action(:reject) { |b| b.reject_button.click; b.loading_wait }
  element(:reject_rationale) { |b| b.div(class: "fancybox-inner").textarea(id: "CM-Reject-Dialog-Explanation_control") }
  action(:confirmation_reject) { |b| b.div(class: "fancybox-inner").span(class: "ui-button-text", text: "Reject").click; b.loading_wait }
  #WITHDRAW
  element(:withdraw_button) {|b|b.button(text: "Withdraw") }
  action(:withdraw) {|b| b.withdraw_button.click; b.loading_wait }
  element(:withdraw_rationale) { |b| b.div(class: "fancybox-inner").textarea(id: "CM-Withdraw-Dialog-Explanation_control") }
  action(:confirmation_withdraw) { |b| b.div(class: "fancybox-inner").span(class: "ui-button-text", text: "Withdraw").click; b.loading_wait }

  #Retire
  element(:retire_proposal_button) { |b| b.button(id: "CM-Course-RetireButton") }
  action(:retire_proposal) { |b| b.retire_proposal_button.click; b.loading_wait }
  action(:retire_continue) { |b| b.div(class: "fancybox-inner").span(class: "ui-button-text", text: "Continue").click; b.loading_wait }
  element(:curriculum_review_process) { |b| b.checkbox(id: "CM-Proposal-Course-Retire-ReviewProcess_control") }
  action (:edit_retire_proposal_link) { |b| b.a(id: "CM-Proposal-Review-RetireCourse-Edit-Link").click; b.loading_wait }

  #COURSE STATUS
  value(:course_state_review) { |b| b.div(id: /CM-ViewCourse-View/).text }

  #highlighted line
  # jQuery('#CM-ViewCourseView-CourseInfo-Course-Titlever1').parent().parent().attr('class') ==
  # "cm-compare-highlighter"
  # use this to check the style

  element(:course_version1_number_review) { |b| b.div(id: "CM-ViewCourse-VersionNamever1") }
  element(:course_version2_number_review)  { |b| b.div(id: "CM-ViewCourse-VersionNamever2") }

  element(:not_current_version_section) {|b|b.div(id: "CM-ViewCourse-View-Course-NotCurentVersionSection")}
  action(:view_course_current_version) { |b| b.a(id: "CM-ViewCourse-View-Course-CurentVersion-Link").click }

  #Course Version History Compare
  #Course information Section

  element(:course_title_ver1_review) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-Course-Titlever1") }
  element(:course_title_ver2_review)  { |b| b.div(id: "CM-ViewCourseView-CourseInfo-Course-Titlever2") }

  element(:transcript_course_ver1_title) { |b| b.div(id: /.*ver1/, data_label: "Transcript Course Title")}
  element(:transcript_course_ver2_title) { |b| b.div(id: /.*ver2/, data_label: "Transcript Course Title")}
  element(:subject_code_ver1) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-Subject-Areaver1")}
  element(:subject_code_ver2) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-Subject-Areaver2")}
  element(:course_number_ver1) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-CourseNumberSuffixver1") }
  element(:course_number_ver2) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-CourseNumberSuffixver2") }

  element(:subject_code_ver1_review) { |b| b.label(id:"CM-ViewCourseView-CourseInfo-Subject-Areaver1_label") }
  element(:course_number_ver1_review) { |b| b.label(id: "CM-ViewCourseView-CourseInfo-CourseNumberSuffixver1_label") }
  element(:cross_listed_courses_ver1_review) { |b| b.label(id: "CM-ViewCourseView-CourseInfo-CrossListingsver1_label") }
  element(:jointly_offered_courses_ver1_review) { |b| b.label(id: "CM-ViewCourseView-CourseInfo-JointlyOfferedCoursesver1_label") }
  element(:version_codes_ver1_review) { |b| b.label(id: "CM-ViewCourseView-CourseInfo-Version-Codesver1_label" )}
  element(:instructors_ver1_review) { |b| b.label(id: 'CM-ViewCourseView-CourseInfo-Instructorsver1_label') }
  element(:description_ver1_review) { |b| b.label(id: "CM-ViewCourseView-CourseInfo-Descrver1_label") }

  # GOVERNANCE REVIEW FIELDS
  element(:campus_locations_ver1_review) { |b| b.label(id: 'CM-ViewCourseView-Governance-CampusLocationsver1_label') }
  element(:curriculum_oversight_ver1_review) { |b| b.label(id: 'CM-ViewCourseView-Governance-CurriculumOversightver1_label') }
  element(:administering_org_ver1_review) { |b| b.label(id: 'CM-ViewCourseView-Governance-AdministeringOrganizationver1_label') }


  # LOGISTICS REVIEW FIELDS
  element(:terms_ver1_review) { |b| b.label(id: 'CM-ViewCourseView-Logistics-Termsver1_label') }
  element(:duration_ver1_review) { |b| b.label(id: 'CM-ViewCourseView-Logistics-DurationTypever1_label') }
  element (:audit_ver1_review) { |b| b.label(id: 'CM-ViewCourseView-Logistics-Auditver1_label') }
  element(:pass_fail_transcript_ver1_review) { |b| b.label(id: 'CM-ViewCourseView-Logistics-PassFailver1_label') }


  element(:assessment_scale_ver1_review) { |b| b.label(id: "CM-ViewCourseView-Logistics-GradingOptionsver1_label")  }
  element(:final_exam_status_ver1_review) { |b| b.label(id: "CM-ViewCourseView-Logistics-FinalExamStatusver1_label") }

  element(:outcome_ver1_review) { |b| b.label(id: "CM-ViewCourse-View-Course-OutcomeSectionver1_label") }
  element(:activity_format_ver1_review_section) { |b| b.label(id:"CM-ViewCourse-View-Course-FormatSectionver1_label") }

  value(:course_version_number_diff_highlighter) { |b| b.course_version1_number_review.parent.parent.attribute_value("class")}
  value(:course_title_version_diff_highlighter) {|b|b.course_title_ver1_review.parent.parent.attribute_value("class") }
  value(:transcript_course_title_diff_highlighter) {|b|b.transcript_course_ver1_title.parent.parent.attribute_value("class") }
  value(:start_term_version_diff_highlighter) {|b|b.start_term_ver1_review.parent.parent.attribute_value("class") }
  value(:end_term_version_diff_highlighter) {|b|b.end_term_ver1_review.parent.parent.attribute_value("class") }

  #LEARNING OBJECTIVES

  #COURSE REQUISITES
  element(:course_requisite_section) {|b|b.div(id: 'CM-ViewCourse-View-Course-Requisites-CollectionSection')}
  #Student Eligibility & Prerequisite
  #Corequisite

  #ACTIVITY FORMATS
  element(:course_format_activity_ver1) {|index, b|b.div(id: "CM-ViewCourse-View-Course-ActivitySectionver1ver2_line#{index}")}
  element(:course_format_activity_ver2) {|index, b|b.div(id: "CM-ViewCourse-View-Course-ActivitySectionver1ver2_line#{index}")}
  # ACTIVE DATES REVIEW FIELDS
  element(:start_term_ver1_review) { |b| b.label(id: "CM-ViewCourseView-ActiveDates-StartTermver1_label") }
  value(:end_term_ver1_review) { |b| b.label(id: 'CM-ViewCourseView-ActiveDates-EndTermver1_label') }
  value(:pilot_course_ver1_review) { |b| b.label(id: 'CM-ViewCourseView-ActiveDates-PilotCoursever1_label') }

  # MODIFY COURSE PROPOSAL FIELDS COMPARE COURSE INFORMATION FIELDS
  element(:new_proposal_title_element) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Proposal-Namenew_control") }
  value(:proposal_title_diff_highlighter) { |b| b.label(id: "CM-ViewCourseView-CourseInfo-Proposal-Namenew_label").parent.parent.attribute_value("class") }
  value(:new_proposal_title_review) { |b| b.new_proposal_title_element.text }
  value(:new_transcript_course_title) { |b| b.textarea(id: /.*new_control/).text}
  value(:old_transcript_course_title) { |b| b.div(id: /.*old/, data_label: "Transcript Course Title").text }
  value(:new_course_title_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Course-Titlenew_control").text }
  value(:old_course_title_review) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-Course-Titleold").text }
  value(:new_subject_code_review) { |b| b.textarea(id:"CM-ViewCourseView-CourseInfo-Subject-Areanew_control").text }
  value(:old_subject_code_review) { |b| b.div(id:"CM-ViewCourseView-CourseInfo-Subject-Areaold").text }
  value(:new_course_number_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-CourseNumberSuffixnew_control").text }
  value(:old_course_number_review) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-CourseNumberSuffixold").text }
  value(:course_number_diff_highlighter) {|b|b.label(id: 'CM-ViewCourseView-CourseInfo-CourseNumberSuffixnew_label').parent.parent.attribute_value("class") }
  value(:course_title_diff_highlighter) {|b|b.label(id: 'CM-ViewCourseView-CourseInfo-Course-Titlenew_label').parent.parent.attribute_value("class") }

  value(:new_description_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Descrnew_control").text }
  value(:old_description_review) { |b| b.div(id: "CM-ViewCourseView-CourseInfo-Descrold").text }
  value(:new_proposal_rationale_review) { |b| b.textarea(id: "CM-ViewCourseView-CourseInfo-Rationalenew_control").text }

  value(:new_start_term_review) { |b| b.textarea(id: "CM-ViewCourseView-ActiveDates-StartTermnew_control").text }
  element(:start_term_element) { |b| b.div(id: "CM-ViewCourseView-ActiveDates-StartTermnew") }
  value(:start_term_diff_highlighter) {|b|b.start_term_element.parent.parent.attribute_value("class") }
  element(:proposal_review_column_title) {|b|b.div(id: 'CM-ViewCourse-VersionNamenew')}
  element(:original_course_review_column_title) {|b|b.div(id: 'CM-ViewCourse-VersionNameold')}

  element(:new_view_course_outcome_detail) {|b|b.div(id: 'CM-ViewCourseView-Outcome-Detailsnew')}
  element(:old_view_course_outcome_detail) {|b|b.div(id: 'CM-ViewCourseView-Outcome-Detailsold')}
  value(:outcome_detail_diff_highlighter) { |b| b.new_view_course_outcome_detail.section(id: /.*_line0/).attribute_value("class") }

end