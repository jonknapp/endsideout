class AdrGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def create_adr_file
    template "adr.md.erb", adr_path
  end

  private

  def adr_path
    "docs/adrs/#{next_number}_#{name.underscore.parameterize(separator: "_")}.md"
  end

  def next_number
    @next_number ||= begin
      highest_existing_adr = Dir.glob(File.join(destination_root, "docs/adrs/[0-9]*.md")).last
      highest_existing_number = highest_existing_adr ? File.basename(highest_existing_adr).to_i : 0
      format("%04d", highest_existing_number + 1)
    end
  end
end
