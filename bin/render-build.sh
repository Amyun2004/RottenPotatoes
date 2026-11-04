#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

bundle install
bin/rails assets:precompile
# Free Render services do not support pre-deploy commands or shell access.
bin/rails db:migrate
bin/rails db:seed
