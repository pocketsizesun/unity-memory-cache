# frozen_string_literal: true

require_relative "lib/unity/memory_cache/version"

Gem::Specification.new do |spec|
  spec.name = "unity-memory-cache"
  spec.version = Unity::MemoryCache::VERSION
  spec.authors = ["Julien D."]
  spec.email = ["julien@pocketsizesun.com"]

  spec.summary = "Unity Memory Cache - A minimalistic in-memory cache storage"
  spec.description = "Unity::MemoryCache is a minimalistic in-memory cache storage, be careful when storing large objects because there is no automatic cleanup process"
  spec.homepage = "https://github.com/pocketsizesun/unity-memory-cache"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pocketsizesun/unity-memory-cache"
  spec.metadata["changelog_uri"] = "https://github.com/pocketsizesun/unity-memory-cache"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
