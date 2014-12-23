require 'rails_helper'

describe Address do
  describe "hq" do
    context "when headquarter address already present" do
      before do
        @hq_address = Address.create! :addressable_type => "hq"
      end

      it "finds hq address" do
        expect(Address.hq).to eq(@hq_address)
      end
    end

    context "when headquarter address not present" do
      it "creates hq address" do
        expect { Address.hq }.to change { Address.count }.by(1)
      end

      it "creates address with addressable_type equal to hq" do
        Address.hq
        expect(Address.last.addressable_type).to eq('hq')
      end
    end
  end

  describe "branch_offices" do
    before do
      @branch_office1 = Address.create!
      @branch_office2 = Address.create!
      @hq_address = Address.create! :addressable_type => "hq"
    end

    it { expect(Address.branch_offices).to eq([@branch_office1, @branch_office2]) }
  end
end