namespace :assets do
  task :webpack_compile do
    system(
      {
        'DIGEST' => 'true',
        'NODE_ENV' => Rails.env
      },
      'node_modules/webpack/bin/webpack.js --display-reasons --display-chunks --progress'
    ) or raise('`npm run webpack` failed!')
  end

  task precompile: :webpack_compile
end
