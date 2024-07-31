#!/bin/bash
set -ex

composer install

./flow doctrine:migrate

./flow server:run --host 0.0.0.0

./flow user:create --roles Administrator $NEOS_ADMIN_USER $NEOS_ADMIN_PASSWORD max mustermann
