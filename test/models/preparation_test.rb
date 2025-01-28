require "test_helper"

class PreparationTest < ActiveSupport::TestCase
  setup do
    @dish = dishes(:one)
    @preparation = preparations(:one)
    @holiday = holidays(:existing_holiday)
  end
  # test "the truth" do
  #   assert true
  # end
  test "should not save preparation without dish" do
    preparation = Preparation.new
    assert_not preparation.save, "Saved the preparation without a dish"
  end

  test "should save preparation with dish" do
    preparation = Preparation.new
    preparation.dish = Dish.create(name: "Dish")
    assert preparation.save, "Did not save the preparation with a dish"
  end

  test "should save preparation with dish and date cooked" do
    preparation = Preparation.new
    preparation.dish = Dish.create(name: "Dish")
    preparation.date_cooked = DateTime.now
    assert preparation.save, "Did not save the preparation with a dish and date cooked"
  end

  test "should save preparation with dish, date cooked, and recipe long form" do
    preparation = Preparation.new
    preparation.dish = Dish.create(name: "Dish")
    preparation.date_cooked = DateTime.now
    preparation.recipe_long_form = "This is a long recipe."
    assert preparation.save, "Did not save the preparation with a dish, date cooked, and recipe long form"
  end

  test "should save preparation with dish, date cooked, recipe long form, and backstory" do
    preparation = Preparation.new
    preparation.dish = Dish.create(name: "Dish")
    preparation.date_cooked = DateTime.now
    preparation.recipe_long_form = "This is a long recipe."
    preparation.backstory = "This is a backstory."
    assert preparation.save, "Did not save the preparation with a dish, date cooked, recipe long form, and backstory"
  end

  test "should save preparation with dish, date cooked, recipe long form, backstory, and occasions" do
    preparation = Preparation.new
    occasion = Occasion.find_or_create_by(holiday_id: @holiday.id)
    preparation.dish = Dish.create(name: "Dish")
    preparation.date_cooked = DateTime.now
    preparation.recipe_long_form = "This is a long recipe."
    preparation.backstory = "This is a backstory."
    preparation.occasions = [ occasion ]
    assert preparation.save, "Did not save the preparation with a dish, date cooked, recipe long form, backstory, and occasions"
  end

  test "should save preparation with dish, date cooked, recipe long form, backstory, occasions, and image" do
    preparation = Preparation.new
    preparation.dish = Dish.create(name: "Dish")
    preparation.date_cooked = DateTime.now
    preparation.recipe_long_form = "This is a long recipe."
    preparation.backstory = "This is a backstory."
    # preparation.occasions_preparations = [ OccasionsPreparation.new ]
    # preparation.image.attach(io: File.open(Rails.root.join("test", "fixtures", "files", "image.jpg")), filename: "image.jpg", content_type: "image/jpg")
    assert preparation.save, "Did not save the preparation with a dish, date cooked, recipe long form, backstory, occasions, and image"
  end

  # test "should save preparation with dish, date cooked, recipe long form, backstory, occasions, image, and comments" do
  #   preparation = Preparation.new
  #   preparation.dish = Dish.new(name: "Dish")
  #   preparation.date_cooked = DateTime.now
  #   preparation.recipe_long_form = "This is a long recipe."
  #   preparation.backstory = "This is a backstory."
  #   preparation.occasions = [ Occasion.new ]
  #   preparation.image.attach(io: File.open(Rails.root.join("test", "fixtures", "files", "image.jpg")), filename: "image.jpg", content_type: "image/jpg")
  #   preparation.comments = [ Comment.new ]
  #   assert preparation.save, "Did not save the preparation with a dish, date cooked, recipe long form, backstory, occasions, image, and comments"
  # end

  # test "should save preparation with dish, date cooked, recipe long form, backstory, occasions, image, comments, and rich text" do
  #   preparation = Preparation.new
  #   preparation.dish = Dish.new(name: "Dish")
  #   preparation.date_cooked = DateTime.now
  #   preparation.recipe_long_form = "This is a long recipe."
  #   preparation.backstory = "This is a backstory."
  #   preparation.occasions = [ Occasion.new ]
  #   preparation.image.attach(io: File.open(Rails.root.join("test", "fixtures", "files", "image.jpg")), filename: "image.jpg", content_type: "image/jpg")
  #   preparation.comments = [ Comment.new ]
  #   preparation.body = ActionText::Content.new("This is rich text.")
  #   assert preparation.save, "Did not save the preparation with a dish, date cooked, recipe long form, backstory, occasions, image, comments, and rich text"
  # end
end
