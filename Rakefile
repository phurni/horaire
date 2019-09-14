# Rakefile
require 'opal'
require 'opal-jquery'

desc "Build our app to app.js"
task :build do
  rm_rf "build"
  cp_r "public/.", "build"
  
  Opal.append_path "app"
  
  builder = Opal::Builder.new
  builder.build('opal')
  builder.build('opal-jquery')
  builder.build('application')

  File.binwrite "build/app.js", builder.to_s
end

desc "Publish build to root (for gh-pages)"
task :publish do
  cp_r "build/.", "."
end
