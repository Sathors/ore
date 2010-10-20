module Ore
  module Defaults
    # The default require-paths
    DEFAULT_REQUIRE_PATHS = %w[lib ext]

    # The glob to find default executables
    DEFAULT_EXECUTABLES = 'bin/*'

    # The globs to find all testing-files
    DEFAULT_TEST_FILES = %w[
      test/{**/}*_test.rb
      spec/{**/}*_spec.rb}
    ]

    # The files to always exclude
    DEFAULT_EXCLUDE_FILES = %w[
      .gitignore
    ]

    protected

    #
    # Sets the project name using the directory name of the project.
    #
    def default_name!
      @name = @root.basename.to_s
    end

    #
    # Finds and sets the version of the project.
    #
    def default_version!
      @version = (
        Versions::VersionFile.find(@root) ||
        Versions::VersionConstant.find(@root)
      )

      unless @version
        raise(InvalidMetadata,"could not find a version file or constant")
      end
    end

    #
    # Sets the release date of the project.
    #
    def default_date!
      @date = Date.today
    end

    #
    # Sets the require-paths of the project.
    #
    def default_require_paths!
      DEFAULT_REQUIRE_PATHS.each do |name|
        @require_paths << name if @root.join(name).directory?
      end
    end

    #
    # Sets the executables of the project.
    #
    def default_executables!
      glob(DEFAULT_EXECUTABLES) do |path|
        check_executable(path) { |exe| @executables << File.basename(exe) }
      end
    end

    #
    # sets the primary executable of the project.
    #
    def default_executable!
      @executable = if @executables.include?(@name)
                      @name
                    else
                      @executables.first
                    end
    end

    #
    # Sets the extra-files of the project.
    #
    def default_extra_files!
      glob('README.*') { |path| add_extra_file(path) }

      if @document
        @document.extra_files.each { |path| add_extra_file(path) }
      end
    end

    #
    # Sets the files of the project.
    #
    def default_files!
      @project_files.each do |file|
        @files << file unless DEFAULT_EXCLUDE_FILES.include?(file)
      end
    end

    #
    # Sets the test-files of the project.
    #
    def default_test_files!
      DEFAULT_TEST_FILES.each do |pattern|
        glob(pattern) { |path| add_test_file(path) }
      end
    end

  end
end
