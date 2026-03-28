class ApplicationActor < Actor
  private

  def fail_with_record!(record, error: nil)
    fail!(error: error || record.errors.full_messages.to_sentence)
  end
end
