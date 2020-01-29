echo "Migrating db, stand by..."
./bin/rails db:migrate
echo "Compiling assets, stand by..."
./bin/rails assets:precompile
echo "Run server."
./bin/rails server -b 0.0.0.0 -p ${PORT}
