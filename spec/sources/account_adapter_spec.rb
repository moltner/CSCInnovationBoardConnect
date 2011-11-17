require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "AccountAdapter" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for AccountAdapter,'testuser'
    end

    it "should process AccountAdapter query" do
        test_query.size.should == 0
        query_errors.should == {}
    end

    it "should process AccountAdapter create" do
      pending
    end

    it "should process AccountAdapter update" do
      pending
    end

    it "should process AccountAdapter delete" do
      pending
    end
  end  
end