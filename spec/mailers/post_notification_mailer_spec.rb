require 'spec_helper'

RSpec.describe PostNotificationMailer, type: :mailer do

  describe 'methods' do
    let(:challenge) { create :challenge, :with_events }
    let(:topic) { create :topic, challenge: challenge }
    let(:post) { create :post, topic: topic }

    it 'successfully sends a message' do
      res = described_class.new.sendmail(post.participant_id,post.id)
      man = MandrillSpecHelper.new(res)
      expect(man.status).to eq 'sent'
      expect(man.reject_reason).to eq nil
    end

    it 'addresses the email to the participant' do
      res = described_class.new.sendmail(post.participant_id,post.id)
      man = MandrillSpecHelper.new(res)
      expect(man.merge_var('NAME')).to eq(post.participant.name)
    end

    it 'produces a body which is correct HTML' do
      res = described_class.new.sendmail(post.participant_id,post.id)
      man = MandrillSpecHelper.new(res)
      expect(man.merge_var('BODY')).to be_a_valid_html_fragment
    end
  end

end
