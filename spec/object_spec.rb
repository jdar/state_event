require 'spec_helper'

class TestObject1 < ActiveRecord::BaseWithoutTable
  column :state, :string
  column :state_changed_at, :datetime
  column :second_state_at, :datetime
  
  acts_as_aasm_object :actor => :foo
  
  aasm_initial_state :first
  aasm_state_fires :first, :actor => :foo
  aasm_state_fires :second, :actor => :foo
  
  def foo
    "bar"
  end
  
  aasm_event :mark_second do
    transitions :to => :second, :from => [:first]
  end

end

describe "Object state interactions" do
  it "should set state_changed_at when there" do
    Timecop.freeze do
      test = TestObject1.new
      test.state_changed_at.should be_nil
      test.second_state_at.should be_nil
      test.save.should be_true
      test.state_changed_at.should == Time.now
      test.second_state_at.should be_nil
    end
  end
  
  it "should set event timestamps when there" do
    Timecop.freeze do
      test = TestObject1.new
      test.mark_second
      test.state_changed_at.should be_nil
      test.second_state_at.should be_nil
      test.save.should be_true
      test.second_state_at.should == Time.now
      test.state_changed_at.should == Time.now
    end
  end
end