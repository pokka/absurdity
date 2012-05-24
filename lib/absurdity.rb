require 'json'
require 'absurdity/railtie.rb' if defined?(Rails)
require 'absurdity/engine' if defined?(Rails)

module Absurdity
  class MissingIdentityIDError < RuntimeError; end

  autoload :Config,     "absurdity/config"
  autoload :Experiment, "absurdity/experiment"
  autoload :Metric,     "absurdity/metric"
  autoload :Variant,    "absurdity/variant"
  autoload :Datastore,  "absurdity/datastore"

  def self.redis=(redis)
    Config.instance.redis = redis
  end

  def self.track!(metric_slug, experiment_slug, identity_id=nil)
    Experiment.find(experiment_slug).track!(metric_slug, identity_id)
  end

  def self.variant(experiment_slug, identity_id)
    Experiment.find(experiment_slug).variant_for(identity_id)
  end

  def self.add_experiment(slug, metrics_list, variants_list)
    Experiment.create(slug, metrics_list, variants_list)
  end
end
