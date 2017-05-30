class ProfileDecorator < LittleDecorator
  def to_s
    record.name
  end

  def neurons
    @neurons ||= Neuron.where(id: record.neuron_ids)
  end

  def moi_tree_form
    source = edit_admin_profile_path(record, format: :json) unless new_record?
    moi_tree hide_dialog: true, source: source
  end

  def all_neurons
    # TODO review this scope
    if current_user.admin?
      Neuron.all
    else
      Neuron.not_deleted
    end
  end
end
