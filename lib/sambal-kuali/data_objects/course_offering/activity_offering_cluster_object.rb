# stores test data for creating/editing and validating activity offering clusters and provides convenience methods for navigation and data entry
#
# ActivityOfferingClusterObject objects are always children of a CourseOffering
#
# ActivityOfferingClusterObject objects are parents of 0 to many RegistrationGroups objects
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Typical usage: (with optional setting of explicit data value in [] )
#  @cluster = make ActivityOfferingClusterObject, [:is_constrained=>true,:private_name=>"test1_pri",:published_name=>"test1_pub"...]
#  @cluster.create
# OR alternatively 2 steps together as
#  @cluster = create ActivityOfferingClusterObject, [:is_constrained=>true,:private_name=>"test1_pri",:published_name=>"test1_pub"...]
# Note the use of the ruby options hash pattern re: setting attribute values
class ActivityOfferingClusterObject < DataFactory

  include Foundry
  include DateFactory
  include StringFactory
  include Workflows
  include Comparable

  #generally set using options hash
  attr_accessor :format,
                :private_name,
                :published_name,
                :is_valid,
                :expected_msg,
                :to_assign_ao_list,
                :ao_list,
                :parent_course_offering

  alias_method :valid?, :is_valid

  # provides default data:
  #  defaults = {
  #    :private_name=>"#{random_alphanums(5).strip}_pri",
  #    :published_name=>"#{random_alphanums(5).strip}_pub",
  #    :is_valid=>true,
  #    :expected_msg=>"",
  #    :ao_list=>[] ,
  #    :parent_course_offering => nil
  #  }
  # initialize is generally called using TestFactory Foundry .make or .create methods
  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :private_name=>"#{random_alphanums(5).strip}_pri",
        :published_name=>"#{random_alphanums(5).strip}_pub",
        :is_valid=>true,
        :expected_msg=>"",
        :ao_list => collection('ActivityOffering'),
        :parent_course_offering => nil
    }
    options = defaults.merge(opts)
    set_options(options)

    @ao_list.each do |ao|
      ao.parent_cluster = self
    end
  end

  def <=>(other)
    @private_name <=> other.private_name
  end

  # while on manage reg groups page, sets up activity offering cluster based on class attributes
  def create
      on ManageCourseOfferings do |page|
        page.add_cluster
        if @format != nil
          #ordering of compound format type (eg Lecture/Discussion) is flexible
          #if the selectlist doesn't include the option, then try reordering
          if !@format.index('/').nil?
            if !page.format_aoc_select.include?(@format)
              formats = @format.split('/')
              @format = "#{formats[1]}/#{formats[0]}"
            end
          end
          page.format_aoc_select.select(@format)
        end
        page.private_name_add.set @private_name
        page.published_name_add.set @published_name
        page.complete_add_aoc
        sleep 3
      end
  end

  def initialize_with_actual_values(cluster_div, parent_co)
    on ManageCourseOfferings do |page|
      @parent_course_offering = parent_co
      @private_name = page.cluster_div_private_name(cluster_div)
      #@public_name = page.cluster_published_name(cluster_div)
      ao_rows = page.get_cluster_div_ao_rows(cluster_div)

      ao_rows.each do |ao_row|
        ao_obj_temp = make ActivityOfferingObject
        ao_obj_temp.initialize_with_actual_values(ao_row, self)
        @ao_list.push(ao_obj_temp)
      end
    end
  end

  # see CourseOffering
  #def add_activity_offering(ao_object)
  #  @ao_list << ao_object.create
  #end

  def ao_code_list
    code_list = []
    ao_list.each do |ao|
      code_list << ao.code
    end
    code_list
  end

  #def get_ao_obj_by_code(ao_code)
  #  @ao_list.select{|ao| ao.code == ao_code}[0]
  #end

  # moves activity offering from cluster to target cluster
  #
  # @param ao_code [String] activity offering code
  # @param target cluster [ActivityOfferingClusterObject] target cluster object
  def move_ao_to_another_cluster(ao_code, target_cluster)
    on ManageCourseOfferings do |page|
      row = page.get_cluster_ao_row(@private_name,ao_code)
      row.cells[0].checkbox.set
      page.move_aos
      page.select_cluster.select(target_cluster.private_name)
      page.complete_move_ao
    end
    moved_ao = @ao_list.select{|ao| ao.code == ao_code}[0]
    target_cluster.ao_list.push(moved_ao)
    @ao_list.delete(moved_ao)
  end

  # moves activity offering from cluster to target cluster
  #
  # @param ao_code [String] activity offering code
  # @param target cluster [ActivityOfferingClusterObject] target cluster object
  def move_all_aos_to_another_cluster(target_cluster)
    on ManageCourseOfferings do |page|
      if page.cluster_select_all_aos(@private_name) then
        page.move_aos
        page.select_cluster.select(target_cluster.private_name)
        page.complete_move_ao
      end
    end
    @ao_list = collection('ActivityOffering')
    target_cluster.ao_list << @ao_list
  end

# deletes the activity offering cluster
  def delete
    on ManageCourseOfferings do |page|
      page.remove_cluster(@private_name)
      page.confirm_delete_cluster
    end
    @ao_list = collection('ActivityOffering')
    @parent_course_offering.activity_offering_cluster_list.delete(self)
  end


  # renames cluster
  #
  # @param opts [Hash] key => value for attribute to be updated
  #
  # defaults = {
  #    :private_name=>"#{random_alphanums(5).strip}_pri",
  #    :published_name=>"#{random_alphanums(5).strip}_pub",
  #    :expect_success=>true
  #}
  def rename(opts={})

    defaults = {
        :private_name=>"#{random_alphanums(5).strip}_pri",
        :published_name=>"#{random_alphanums(5).strip}_pub",
        :expect_success=>true
    }
    options = defaults.merge(opts)

     on ManageCourseOfferings do |page|
       page.rename_cluster(@private_name)
       set_options(options) if options[:expect_success]
       page.rename_private_name.set @private_name
       page.rename_published_name.set @published_name
       page.rename_aoc_button
     end
  end


end

class ActivityOfferingClusterCollection < CollectionsFactory
  contains ActivityOfferingClusterObject

  def by_private_name(private_name)
    return self[0] if private_name == :default_cluster
    self.find {|cluster| cluster.private_name == private_name }
  end
end