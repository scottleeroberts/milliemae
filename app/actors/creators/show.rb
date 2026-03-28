class Creators::Show < ApplicationActor
  input :username, type: String

  output :creator
  output :projects

  def call
    self.creator = User.creator.includes(:followers).find_by!(username: username)
    self.projects = creator.projects.for_feed
                           .includes(:tags, :likes, :comments, :rich_text_body,
                                     project_images: { image_attachment: :blob })
  end
end
