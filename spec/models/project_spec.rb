require "rails_helper"

RSpec.describe Project, type: :model do
  describe "validations" do
    subject(:project) { build(:project) }

    it "is valid with valid attributes" do
      expect(project).to be_valid
    end

    it "requires a title" do
      project.title = ""
      expect(project).not_to be_valid
      expect(project.errors[:title]).to include("can't be blank")
    end

    it "requires a slug" do
      project.slug = ""
      expect(project).not_to be_valid
      expect(project.errors[:slug]).to include("can't be blank")
    end

    it "requires a unique slug" do
      create(:project, slug: "my-project")
      project.slug = "my-project"
      expect(project).not_to be_valid
      expect(project.errors[:slug].first).to include("has already been taken")
    end
  end

  describe "slug generation" do
    it "generates a slug from the title on create" do
      project = create(:project, title: "My Beautiful Dress")
      expect(project.slug).to eq("my-beautiful-dress")
    end

    it "does not overwrite a slug set manually" do
      project = create(:project, title: "My Beautiful Dress", slug: "custom-slug")
      expect(project.slug).to eq("custom-slug")
    end

    it "does not auto-update slug when title changes" do
      project = create(:project, title: "Original Title")
      original_slug = project.slug
      project.update!(title: "New Title")
      expect(project.slug).to eq(original_slug)
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      project = build(:project, slug: "my-dress")
      expect(project.to_param).to eq("my-dress")
    end
  end

  describe "tagging" do
    it "assigns tags via tag_list=" do
      project = create(:project)
      project.tag_list = "cotton, dress, floral"
      project.save!
      expect(project.tags.map(&:name)).to match_array([ "cotton", "dress", "floral" ])
    end

    it "downcases tag names" do
      project = create(:project)
      project.tag_list = "Cotton, DRESS"
      project.save!
      expect(project.tags.map(&:name)).to match_array([ "cotton", "dress" ])
    end

    it "deduplicates tag names" do
      project = create(:project)
      project.tag_list = "cotton, cotton, dress"
      project.save!
      expect(project.tags.count).to eq(2)
    end

    it "returns tag_list as comma-separated string" do
      project = create(:project)
      project.tag_list = "cotton, dress"
      project.save!
      expect(project.reload.tag_list.split(", ")).to match_array([ "cotton", "dress" ])
    end

    it "reuses existing tags" do
      create(:tag, name: "cotton")
      project = create(:project)
      expect { project.tag_list = "cotton"; project.save! }.not_to change(Tag, :count)
    end

    it "deduplicates tag names regardless of case" do
      project = create(:project)
      project.tag_list = "Cotton, cotton, COTTON"
      project.save!
      expect(project.tags.count).to eq(1)
      expect(project.tags.first.name).to eq("cotton")
    end
  end

  describe "#publish!" do
    it "marks the project as published with a timestamp" do
      project = create(:project)
      freeze_time do
        project.publish!
        expect(project).to be_published
        expect(project.published_at).to be_within(1.second).of(Time.current)
      end
    end
  end

  describe "#unpublish!" do
    it "marks the project as draft and clears published_at" do
      project = create(:project, :published)
      project.unpublish!
      expect(project).not_to be_published
      expect(project.published_at).to be_nil
    end
  end

  describe "#published_date" do
    it "returns a formatted date when published" do
      project = build(:project, published_at: Time.zone.parse("2026-03-22"))
      expect(project.published_date).to eq("Twirled on Mar 22, 2026")
    end

    it "returns 'Not published yet' when not published" do
      project = build(:project, published_at: nil)
      expect(project.published_date).to eq("Not published yet")
    end
  end

  describe "scopes" do
    let!(:draft) { create(:project) }
    let!(:published) { create(:project, :published) }

    it "scopes to published" do
      expect(Project.published).to contain_exactly(published)
    end

    it "scopes to draft" do
      expect(Project.draft).to contain_exactly(draft)
    end
  end

  describe "associations" do
    it "destroys project_tags when destroyed" do
      project = create(:project, :with_tags)
      expect { project.destroy }.to change(ProjectTag, :count).by(-2)
    end

    it "requires a user" do
      project = build(:project, user: nil)
      expect(project).not_to be_valid
      expect(project.errors[:user]).to be_present
    end
  end

  describe "body (Action Text)" do
    it "stores and retrieves rich text content" do
      project = create(:project)
      project.update!(body: "<p>A beautiful sewing project</p>")
      expect(project.reload.body.to_s).to include("A beautiful sewing project")
    end

    it "is optional — project is valid without a body" do
      expect(build(:project)).to be_valid
    end
  end

  describe "#tag_list= replacement behaviour" do
    it "replaces existing tags entirely when reassigned" do
      project = create(:project)
      project.tag_list = "cotton, dress"
      project.save!
      project.tag_list = "silk, blouse"
      project.save!
      expect(project.reload.tags.map(&:name)).to match_array([ "silk", "blouse" ])
    end

    it "clears all tags when assigned an empty string" do
      project = create(:project, :with_tags)
      project.tag_list = ""
      project.save!
      expect(project.reload.tags).to be_empty
    end

    it "clears all tags when assigned nil" do
      project = create(:project, :with_tags)
      project.tag_list = nil
      project.save!
      expect(project.reload.tags).to be_empty
    end
  end

  describe "slug collision" do
    it "is invalid when another project has the same derived slug" do
      create(:project, title: "Summer Dress")
      duplicate = build(:project, title: "Summer Dress")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:slug].first).to include("has already been taken")
    end
  end

  describe ".recent scope ordering" do
    it "orders published projects by published_at descending" do
      older  = create(:project, :published, published_at: 3.days.ago)
      newer  = create(:project, :published, published_at: 1.day.ago)
      middle = create(:project, :published, published_at: 2.days.ago)
      expect(Project.published.recent.to_a).to eq([ newer, middle, older ])
    end

    it "places drafts (NULL published_at) before published projects in PostgreSQL DESC ordering" do
      published = create(:project, :published, published_at: 1.day.ago)
      draft     = create(:project)
      # PostgreSQL ORDER BY published_at DESC defaults to NULLS FIRST —
      # drafts sort above published projects. This is intentional for the
      # creator dashboard (see design note in project plan).
      expect(Project.recent.map(&:id)).to eq([ draft.id, published.id ])
    end
  end

  describe "#publish! idempotency" do
    it "updates published_at when called on an already-published project" do
      project = create(:project, :published, published_at: 1.week.ago)
      original = project.published_at
      travel_to(1.day.from_now) do
        project.publish!
        expect(project.published_at).not_to eq(original)
      end
    end
  end

  describe "#unpublish! idempotency" do
    it "is a no-op on a project that is already a draft" do
      project = create(:project)
      expect { project.unpublish! }.not_to raise_error
      expect(project).not_to be_published
    end
  end
end
