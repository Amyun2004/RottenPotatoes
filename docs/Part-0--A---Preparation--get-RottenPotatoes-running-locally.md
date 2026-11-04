# Part 0 (A) - Preparation: get RottenPotatoes running locally

Run these commands from the `project4` directory, which contains `Gemfile`, `app`, and `config`. Do not run `rails new`: you already have a complete starter app.

## Ruby and gems

Use Ruby **4.0.6** and Rails **8.1.4**. 

```sh
bundle config set --local without 'production'
bundle install
bin/rails --version
bin/rails db:migrate
bin/rails db:seed
bin/rails server
```

Visit <http://localhost:3000/>. Stop the server with Ctrl+C.

`bundle config` skips the production-only PostgreSQL driver locally; SQLite is used for development and tests. The project-specific setting is saved in `.bundle/config`, which is ignored by Git. `bin/rails` runs this application's Rails version through Bundler.


## Check your database

The database location is specified in `config/database.yml`. Migrations in `db/migrate` create the `movies` table. We will commit the generated `db/schema.rb`.

`db/seeds.rb` supplies ten movies. You may run `bin/rails db:seed` again; it adds missing seed titles without duplicating existing titles or replacing edited records.

Run `bin/rails console` to inspect records, for example `Movie.count`. Exit with `exit`.

## Git setup

Start with a committed `main` branch before creating feature branches:

```sh
git init -b main
git status
git add .
git commit -m "Set up RottenPotatoes starter"
```
If this folder is already a Git repository, skip `git init` and use its existing `main` branch. 

Deploy the working starter before beginning Part 1. Then create a feature branch with `git checkout -b add-filtering` and commit your changes frequently.

-----

Next: [Part 0 (B) - Preparation: deploy to Render](Part-0--B---Preparation--deploy-to-Render.md)
