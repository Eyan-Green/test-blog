# spec/support/trix_helpers.rb
module TrixHelpers
  def fill_in_trix_editor(id, with:)
    find("input[type='hidden'][id='#{id}']", visible: false)
      .set(with)
  end
end
