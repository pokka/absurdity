require 'test_helper'

class AbsurdityTest < MiniTest::Unit::TestCase

  def test_track_missing_experiment
    Absurdity.redis = MockRedis.new

    assert_raises Absurdity::Experiment::NotFoundError do
      Absurdity.track! :clicked, :shared_contacts_link
    end
  end

  def test_track_missing_metric
    Absurdity.redis = MockRedis.new
    Absurdity::Experiment.create(:shared_contacts_link,
                                 [:clicked])

    assert_raises Absurdity::Metric::NotFoundError do
      Absurdity.track! :seen, :shared_contacts_link
    end
  end

  def test_track_missing_identity_id
    Absurdity.redis = MockRedis.new
    Absurdity::Experiment.create(:shared_contacts_link,
                                 [:clicked],
                                 [:with_photos, :without_photos])

    assert_raises Absurdity::MissingIdentityIDError do
      Absurdity.track! :seen, :shared_contacts_link
    end
  end

  def test_track_experiment_metric_without_variants
    Absurdity.redis = MockRedis.new
    Absurdity::Experiment.create(:shared_contacts_link,
                                 [:clicked])

    Absurdity.track! :clicked, :shared_contacts_link
    assert_equal 1, Absurdity::Experiment.find(:shared_contacts_link).count(:clicked)
  end

  def test_track_experiment_metric_with_variants
    Absurdity.redis = MockRedis.new
    Absurdity::Experiment.any_instance.expects(:random_variant).returns(:with_photos)

    Absurdity::Experiment.create(:shared_contacts_link,
                                [:clicked],
                                [:with_photos, :without_photos])

    Absurdity.track! :clicked, :shared_contacts_link, 1
    count = Absurdity::Experiment.find(:shared_contacts_link).count(:clicked)

    assert_equal 1, count[:with_photos]
    assert_equal 0, count[:without_photos]
  end

  def test_track_experiment_with_multiple_metrics_with_variants
    Absurdity.redis = MockRedis.new
    Absurdity::Experiment.any_instance.expects(:random_variant).returns(:with_photos)

    Absurdity::Experiment.create(:shared_contacts_link,
                                 [:clicked, :seen],
                                 [:with_photos, :without_photos])

    Absurdity.track! :clicked, :shared_contacts_link, 1
    Absurdity.track! :seen, :shared_contacts_link, 1
    count = Absurdity::Experiment.find(:shared_contacts_link).count(:clicked)

    assert_equal 1, count[:with_photos]
    assert_equal 0, count[:without_photos]

    count = Absurdity::Experiment.find(:shared_contacts_link).count(:seen)
    assert_equal 1, count[:with_photos]
    assert_equal 0, count[:without_photos]
  end

  def test_variant
    Absurdity.redis = MockRedis.new
    Absurdity::Experiment.any_instance.expects(:random_variant).returns(:with_photos)

    Absurdity::Experiment.create(:shared_contacts_link,
                                 [:clicked, :seen],
                                 [:with_photos, :without_photos])

    assert_equal :with_photos, Absurdity.variant(:shared_contacts_link, 1)
  end

  def test_adding_an_experiment
    Absurdity.redis = MockRedis.new

    Absurdity.add_experiment(:sign_up_link, [:signed_up], [:normal, :bold])
    experiment = Absurdity::Experiment.find(:sign_up_link)

    assert_equal :sign_up_link,    experiment.slug
    assert_equal [:signed_up],     experiment.metrics_list
    assert_equal [:normal, :bold], experiment.variants_list
  end
end

