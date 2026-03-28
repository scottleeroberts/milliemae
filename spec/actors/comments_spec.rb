require "rails_helper"

RSpec.describe "Comment actors" do
  describe Comments::Create do
    let(:project) { create(:project, :published) }
    let(:user) { create(:user) }

    it "creates a comment" do
      expect {
        described_class.call(project: project, user: user, attributes: { body: "Lovely work!" })
      }.to change(Comment, :count).by(1)
    end

    it "fails with invalid content" do
      result = described_class.result(project: project, user: user, attributes: { body: "" })

      expect(result).to be_failure
      expect(result.comment.errors[:body]).to be_present
    end
  end

  describe Comments::Destroy do
    let!(:comment) { create(:comment) }

    it "allows the owner to delete the comment" do
      expect {
        described_class.call(comment_record: comment, current_user: comment.user)
      }.to change(Comment, :count).by(-1)
    end

    it "fails for an unauthorized user" do
      result = described_class.result(comment_record: comment, current_user: create(:user))

      expect(result).to be_failure
      expect(result.error).to eq("Not authorized.")
    end
  end
end
