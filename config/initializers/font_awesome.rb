Rails.application.configure do
  config.font_awesome = YAML.load_file(Rails.root.join('config', 'font_awesome.yml'))
end
