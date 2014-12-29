require 'rails_helper'

describe User do
  it { should have_and_belong_to_many(:departments) }
  it { should have_and_belong_to_many(:regions) }
  it { should have_and_belong_to_many(:business_units) }
  it { should have_and_belong_to_many(:job_titles) }
  it { should have_and_belong_to_many(:weekly_offs) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:reset_password_token) }

  describe "with_email" do
    before do
      @user1 = FactoryGirl.create :user, :email => "mail1@example.com"
      @user2 = FactoryGirl.create :user, :email => "mail2@example.com"
    end

    it { expect(User.with_email('mail2@example.com')).to eq([@user2]) }
  end

  describe "with_password" do
    before do
      @user1 = FactoryGirl.create :user
      @user2 = FactoryGirl.create :user, :password => nil, :skip_password_validation => true
      @user3 = FactoryGirl.create :user, :password => nil, :skip_password_validation => true
      @user4 = FactoryGirl.create :user
    end

    it { expect(User.with_password).to eq([@user1, @user4]) }
  end

  describe "before_save" do
    before do
      @user = FactoryGirl.build :user
    end

    it "ensures auth_token" do
      expect(@user).to receive(:ensure_auth_token)
      @user.save
    end

    it "sets reset_password_token" do
      expect(@user).to receive(:set_reset_password_token)
      @user.save
    end
  end

  describe "after_create" do
    before do
      @user = FactoryGirl.build :user
    end

    it "sends invite_mail" do
      expect(@user).to receive(:send_invite_mail)
      @user.save
    end
  end

  describe "#password_not_required?" do
    before do
      @user = User.new
    end

    def password_not_required?
      @user.send :password_not_required?
    end

    context "when skip_password_validation is true" do
      before do
        @user.skip_password_validation = true
      end

      it { expect(password_not_required?).to eq(true) }
    end

    context "when skip_password_validation is false" do
      before do
        @user.skip_password_validation = false
      end

      context "when password_digest already present" do
        before do
          @user.password_digest = "password digest"
        end

        it { expect(password_not_required?).to eq(true) }
      end

      context "when password_digest not present" do
        it { expect(password_not_required?).to eq(false) }
      end
    end
  end

  describe "#set_reset_password_token" do
    before do
      @user = FactoryGirl.create :user
      @user.stub(:generate_token).and_return('reset_token')
      @current_time = Time.current
      Time.stub(:current).and_return(@current_time)
    end

    def set_reset_password_token
      @user.send :set_reset_password_token
    end

    it "sets reset_password_sent_at" do
      set_reset_password_token
      expect(@user.reset_password_sent_at).to eq(@current_time)
    end

    it "sets reset_password_token" do
      set_reset_password_token
      expect(@user.reset_password_token).to eq('reset_token')
    end
  end

  describe "#send_invite_mail" do
    before do
      @user = FactoryGirl.create :user, :email => 'email'
      UserMailer.stub(:delay).and_return(UserMailer)
    end

    def send_invite_mail
      @user.send :send_invite_mail
    end

    it "sends invite mail" do
      expect(UserMailer).to receive(:invite_mail).with('email', @user.reset_password_token)
      send_invite_mail
    end

    it "enqueues invite mail" do
      expect(UserMailer).to receive(:delay).and_call_original
      send_invite_mail
    end
  end
end