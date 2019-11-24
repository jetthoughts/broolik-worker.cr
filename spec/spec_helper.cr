require "spec"

#require "sqlite3"
#require "granite/adapter/sqlite"
#Granite::Connections << Granite::Adapter::Sqlite.new(name: "sqlite", url: "sqlite3:./broolik.db")

require "../src/broolik-worker"
require "../src/broolik-worker/services"

URL.migrator.drop_and_create
Spec.after_each { URL.clear }
