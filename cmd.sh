echo "Migrating db, stand by..."
./bin/rails db:migrate
echo "Run server."
./bin/rails server -b 0.0.0.0 -p ${PORT}
