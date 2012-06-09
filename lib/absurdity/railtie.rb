module Absurdity
  class Railtie < ::Rails::Railtie
    config.after_initialize do
      Config.instance.logger = ::Rails.logger
      load_experiments
    end

    def self.load_experiments
      return unless File.exists?("absurdity/experiments.yml")

      experiments_to_create = YAML.load_file("absurdity/experiments.yml")[:experiments]
      experiments_to_create.each do |experiment_slug, values|
        metrics_list = values[:metrics]
        variants_list = values[:variants]
        experiment = new_experiment(experiment_slug, metrics_list, variants_list)
        complete(experiment_slug, values[:completed]) if values[:completed] && !experiment.completed
      end
    end

    def self.new_experiment(experiment_slug, metrics_list, variants_list=nil)
      begin
        experiment = Experiment.find(experiment_slug)
      rescue Experiment::NotFoundError
        Experiment.create(experiment_slug, metrics_list, variants_list)
      end
    end

    def self.complete(experiment_slug, variant_slug)
      experiment = Experiment.find(experiment_slug)
      experiment.complete(variant_slug)
    end

  end
end