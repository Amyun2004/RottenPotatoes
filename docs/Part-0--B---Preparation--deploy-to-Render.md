# Part 0 (B) - Preparation: deploy to Render

The starter uses SQLite locally and PostgreSQL on Render. Deployment installs the production gems, precompiles assets, migrates the database, and inserts missing seed movies.

## 1. Push the starter to GitHub

Complete the local setup first, including generating and committing `Gemfile.lock` and `db/schema.rb`. Create an **empty private repository** on GitHub, for example `cs457-project4-rottenpotatoes`. Do not add a README, license, or .gitignore on GitHub.

From the `project4` directory:

```sh
git remote add origin https://github.com/YOUR_USERNAME/cs457-project4-rottenpotatoes.git
git push -u origin main
```

Replace `YOUR_USERNAME`. If `origin` already exists, inspect it with `git remote -v`; use `git remote set-url origin <YOUR_REPOSITORY_URL>` if it points to a different repository. Authenticate using your established GitHub method; a GitHub account password does not authenticate HTTPS Git pushes.

## 2. Create a PostgreSQL database

In the [Render dashboard](https://dashboard.render.com/), choose **New → Postgres**. Name it something like `rottenpotatoes-db`, choose a region, and select the Free instance if available. Wait for it to become available. Copy its **Internal Database URL** for the next step.

Use the same region for the web service. If you already have a free Render database from an earlier assignment, Render permits only one active free Postgres database per workspace. You may suspend the earlier database.  I will ask you to resume it if needed for grading purposes.

## 3. Create a web service

Choose **New → Web Service**, connect GitHub, grant access to this private repository, and select it.

| Setting | Value |
| --- | --- |
| Runtime / Language | Ruby (choose Ruby even if Render detects the Dockerfile) |
| Branch | `main` |
| Root Directory | Leave blank when `Gemfile` is at the repository root |
| Build Command | `bash bin/render-build.sh` |
| Start Command | `bundle exec puma -C config/puma.rb -b tcp://0.0.0.0:$PORT` |
| Health Check Path | `/up` |
| Instance Type | Free, if available |
| Auto-Deploy | On Commit |

If you committed a parent directory containing `project4`, set Root Directory to `project4` instead. The recommended approach is to make `project4` itself the repository root.

Add these environment variables before deploying:

| Key | Value |
| --- | --- |
| `RAILS_ENV` | `production` |
| `DATABASE_URL` | Your database's Internal Database URL |
| `SECRET_KEY_BASE` | A new secret generated with `bin/rails secret` locally |
| `BUNDLE_WITHOUT` | `development:test` |
| `RAILS_MAX_THREADS` | `5` |
| `WEB_CONCURRENCY` | `1` |

Keep `SECRET_KEY_BASE` unchanged across deployments so session cookies remain valid. Do not put it or the database URL in Git, screenshots, or your submission. This starter does not use encrypted credentials; it needs `SECRET_KEY_BASE`, not a shared `RAILS_MASTER_KEY`.

Ruby is selected by `.ruby-version` and the generated lockfile. Verify the build log shows Ruby 4.0.6 and Rails 8.1.4. Do not set `BUNDLE_WITHOUT=production` on Render: that would omit `pg`.

Create the service and inspect its deployment logs. The included build script runs migrations and seeds because Free services do not provide pre-deploy commands or shell access. For a paid deployment, migrations can instead run in a pre-deploy command; avoid running them in both places.

Open your `https://...onrender.com` URL and confirm the movie list appears. Create, edit, and delete a movie to verify database writes. Record the URL in `rottenpotatoes-url.txt`.

## 4. Deploy later changes

Render follows `main`. Work on a feature branch, commit, and merge it into `main`, then push:

```sh
git checkout main
git merge YOUR_FEATURE_BRANCH
git push origin main
```

Replace `YOUR_FEATURE_BRANCH` with the branch you finished. Check Render's Events/Logs for the new deployment, then verify the live app. If auto-deploy is disabled, choose **Manual Deploy → Deploy latest commit**.

You can also push a feature branch and open a pull request on GitHub. After merging there, run `git checkout main` and `git pull --ff-only origin main` locally before creating your next feature branch.

## Troubleshooting

- **`pg is not part of the bundle`:** Check that `pg` is in the production Gemfile group, the new lockfile is committed, and `BUNDLE_WITHOUT` is `development:test` on Render.
- **Wrong Ruby or Rails version:** Check `.ruby-version`, Gemfile, the committed lockfile, and the service's root directory. Do not restore the old lockfile.
- **Missing `movies` table:** Inspect the build log for migration failures and verify `DATABASE_URL` points to the intended database.
- **Missing secret:** Set `SECRET_KEY_BASE` in the web service environment and redeploy.
- **Redirect loop:** The starter enables `config.assume_ssl` and `config.force_ssl` for Render's HTTPS proxy.
- **No open port:** Use the exact start command above; it binds to `0.0.0.0` and Render's `$PORT`.
- **Database suddenly inaccessible:** Check its expiration date and status.

References: [Render's Rails 8 deployment guide](https://render.com/docs/deploy-rails-8), [Ruby version selection](https://render.com/docs/ruby-version), and [free service limitations](https://render.com/docs/free).

-----

Next: [Part 1: Filter the list of movies by rating](Part-1--Filter-the-list-of-movies-by-rating.md)
