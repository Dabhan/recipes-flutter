#!/bin/sh

# Decrypt the file
mkdir $HOME/secrets
# --batch to prevent interactive command --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$GOOGLE_PLAY_SERVICE_ACCOUNT_SECRET_PASSPHRASE" \
--output $HOME/secrets/google-play-service.json android/google-play-service.json.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$ANDROID_GOOGLE_JSON_ENCRYPTION_SECRET" \
--output $HOME/secrets/google-services.json android/app/google-services.json.gpg