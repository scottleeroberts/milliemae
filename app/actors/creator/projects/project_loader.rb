class Creator::Projects::ProjectLoader < ApplicationActor
  input :user, type: User
  input :slug, type: String

  output :project

  def call
    self.project = user.projects
                       .includes(project_images: :product_links)
                       .find_by!(slug: slug)
  end
end
